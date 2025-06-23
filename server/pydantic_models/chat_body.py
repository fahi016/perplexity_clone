from pydantic import BaseModel
# this is basically a type safety for the data that is sent to the server, only string is allowed
class ChatBody(BaseModel):
    query: str
