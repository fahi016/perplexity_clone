# perplexity_clone

A full-stack, cross-platform AI-powered chat and search application inspired by Perplexity AI. Built with Flutter (frontend) and Python FastAPI (backend), using Supabase for authentication and database, and Gemini (Google Generative AI) for LLM responses.

---

## Features

- **User Authentication:** Sign up, login, and session management via Supabase.
- **Chat with AI:** Users can ask questions; the app streams AI-generated answers in real time.
- **Web Search Integration:** Answers are enhanced with web search results and sources.
- **YouTube Integration:** Relevant YouTube videos are fetched and displayed alongside answers.
- **Chat History:** Users can view their previous chats.
- **Responsive UI:** Modern, responsive design for web and mobile.
- **Streaming:** Real-time answer streaming using WebSockets.

---

## Architecture

### Frontend (Flutter)

- **Entry Point:** `lib/main.dart` initializes environment variables and Supabase, then launches the app.
- **Auth Flow:** `AuthGate` listens for auth state changes and routes users to either `HomePage` (if logged in) or `LoginPage`.
- **Home Page:** Users can search/ask questions. The UI is split into a sidebar, search section, and status bar.
- **Chat Page:** Displays the question, AI answer (streamed), web sources, and YouTube videos. Uses widgets like `AnswerSection`, `SourcesSection`, and `YouTubeSection`.
- **Services:** 
  - `chat_web_service.dart` manages the WebSocket connection to the backend for chat/answer streaming.
  - `database_service.dart` handles chat history and answer storage via Supabase.

### Backend (Python/FastAPI)

- **WebSocket Endpoint:** `/ws/chat` handles chat requests, performs web search, fetches YouTube results, streams LLM answers, and updates the database.
- **LLM Service:** Uses Gemini API to generate answers, streaming them chunk by chunk.
- **Database Service:** Manages chat records in Supabase.
- **Search & YouTube Services:** Fetch and sort web and YouTube results for context.

---

## Setup & Installation

### Prerequisites

- Flutter SDK
- Python 3.9+
- Supabase project (get your URL and anon/public key)
- Google Gemini API key, YouTube API key, Tavily API key

### 1. Clone the repository

```sh
git clone https://github.com/fahi016/perplexity_clone.git
cd perplexity_clone
```

### 2. Environment Variables

Create a `.env` file in the project root:

```
SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_URL=your_supabase_url
```

Create a `.env` file in the `server/` directory:

```
SUPABASE_URL=your_supabase_url
SUPABASE_KEY=your_supabase_service_role_key
GEMINI_API_KEY=your_gemini_api_key
YOUTUBE_API_KEY=your_youtube_api_key
TAVILY_API_KEY=your_tavily_api_key
```

### 3. Install Dependencies

#### Flutter

```sh
flutter pub get
```

#### Python (Backend)

```sh
cd server
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows
pip install -r requirements.txt
```

### 4. Run the App

#### Backend

```sh
cd server
uvicorn main:app --reload
```

#### Frontend

```sh
flutter run -d chrome   # for web
flutter run             # for mobile/desktop
```

---

## Usage

- Sign up or log in.
- Ask questions in the search bar.
- View AI answers, web sources, and YouTube videos.
- Browse your chat history.

---

## Tech Stack

- **Frontend:** Flutter, Supabase, WebSockets, Google Fonts, YouTube Player
- **Backend:** FastAPI, Supabase, Gemini API, Tavily API, YouTube Data API
- **Database:** Supabase (PostgreSQL)
- **Authentication:** Supabase Auth

---

## License

MIT

