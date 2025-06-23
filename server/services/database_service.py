# services/database_service.py
"""
Centralised helper for the `public.chats` table + RPC
─────────────────────────────────────────────────────
• create_chat()         → returns new chat UUID
• append_answer_chunk() → calls SQL function append_answer_chunk()
• finish_chat()         → stores final answer, sources & youtube JSON
"""

from __future__ import annotations
import os
from typing import List, Any

from supabase import create_client, Client
from dotenv import load_dotenv

load_dotenv()  # Reads SUPABASE_URL / SUPABASE_KEY from .env

_SUPABASE_URL = os.getenv("SUPABASE_URL")
_SUPABASE_KEY = os.getenv("SUPABASE_KEY")

if not _SUPABASE_URL or not _SUPABASE_KEY:
    raise RuntimeError("SUPABASE_URL / SUPABASE_KEY not set in environment")

_client: Client = create_client(_SUPABASE_URL, _SUPABASE_KEY)


# ──────────────────────────────────────────────────────────────────────────────
# Public API
# ──────────────────────────────────────────────────────────────────────────────
def create_chat(user_id: str, question: str) -> str:
    """
    Insert a new row in `public.chats` and return its UUID.
    `preview` is just the first 60 chars of the question.
    """
    row = (
        _client.table("chats")
        .insert(
            {
                "user_id":  user_id,
                "question": question,
                "preview":  question[:60],
            }
        )
        .execute()
        .data[0]
    )
    return row["id"]


def append_answer_chunk(chat_id: str, chunk: str) -> None:
    """
    Call the PostgreSQL function you defined:
        append_answer_chunk(chat_id uuid, chunk text)
    """
    _client.rpc(
        "append_answer_chunk",
        {"chat_id": chat_id, "chunk": chunk},
    ).execute()


def finish_chat(
    chat_id: str,
    answer_full: str,
    sources: List[Any],
    youtube: List[Any],
) -> None:
    """
    Update the row once streaming is done.
    """
    _client.table("chats").update(
        {
            "answer_full": answer_full,
            "sources":     sources,
            "youtube":     youtube,
        }
    ).eq("id", chat_id).execute()
