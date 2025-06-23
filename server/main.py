import asyncio
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.responses import JSONResponse

from pydantic_models.chat_body import ChatBody
from services.youtube_service import YouTubeService
from services.llm_service import LLMService
from services.search_service import SearchService
from services.sort_source_service import SortSourceService
from services.database_service import create_chat, append_answer_chunk, finish_chat

app = FastAPI()
search_service = SearchService()
sort_source_service = SortSourceService()
llm_service = LLMService()
youtube_service = YouTubeService()

@app.websocket("/ws/chat")
async def chat_websocket(websocket: WebSocket):
    await websocket.accept()
    try:
        await asyncio.sleep(0.1)
        data = await websocket.receive_json()
        query = data.get("query")
        user_id = data.get("user_id")

        # Step 1: Create chat row in DB
        chat_id = create_chat(user_id=user_id, question=query)
        await websocket.send_json({"type": "chat_id", "data": chat_id})

        # Step 2: Web search & sort
        search_results = search_service.web_search(query)
        sorted_results = sort_source_service.sort_sources(query, search_results)
        await websocket.send_json({"type": "search_result", "data": sorted_results})

        # Step 3: YouTube fetch
        youtube_results = []
        try:
            yt_response = youtube_service.search_videos(query)
            youtube_items = yt_response.get("items", [])

            for item in youtube_items:
                video_id = item["id"]["videoId"]
                snippet = item["snippet"]
                youtube_results.append({
                    "title": snippet["title"],
                    "videoId": video_id,
                    "url": f"https://www.youtube.com/watch?v={video_id}",
                    "thumbnail": snippet["thumbnails"]["high"]["url"],
                    "channelTitle": snippet["channelTitle"],
                })

            await websocket.send_json({"type": "youtube_result", "data": youtube_results})
        except Exception as yt_err:
            print(f"[YouTube ERROR] {yt_err}")

        # Step 4: LLM Streaming
        full_answer = ""
        for chunk in llm_service.generate_response(query, sorted_results):
            await websocket.send_json({'type': 'content', 'data': chunk})
            full_answer += chunk
            append_answer_chunk(chat_id, chunk)

        # Step 5: Final DB save
        finish_chat(
            chat_id=chat_id,
            answer_full=full_answer,
            sources=sorted_results,
            youtube=youtube_results,
        )

    except WebSocketDisconnect:
        print("WebSocket disconnected")
    except Exception as e:
        print(f"Unexpected error: {e}")
    finally:
        await websocket.close()


@app.post("/chat")
def chat_endpoint(body: ChatBody):
    search_results = search_service.web_search(body.query)
    sorted_results = sort_source_service.sort_sources(body.query, search_results)
    response = llm_service.generate_response(body.query, sorted_results)
    return response


@app.get("/youtube/videos")
def get_youtube_videos(query: str):
    try:
        videos = youtube_service.search_videos(query)
        return JSONResponse(content=videos)
    except Exception as e:
        print(f"Error in fetching YouTube videos: {e}")
        return JSONResponse(content={"error": str(e)}, status_code=500)
