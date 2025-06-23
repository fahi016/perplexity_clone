from googleapiclient.discovery import build
from config import Settings

settings = Settings()
youtube_api_key = settings.YOUTUBE_API_KEY

class YouTubeService:
    def __init__(self):
        self.youtube = build("youtube", "v3", developerKey=youtube_api_key)

    def search_videos(self, query: str, max_results: int = 5):
        try:
            request = self.youtube.search().list(
                q=query,
                part="snippet",
                type="video",
                maxResults=max_results
            )
            response = request.execute()
            return response
            print(response)
        except Exception as e:
            raise RuntimeError(f"Failed to fetch YouTube videos: {e}")
