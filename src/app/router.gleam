import app/web
import gleam/string_tree
import wisp

pub fn handle_request(req: wisp.Request) -> wisp.Response {
  use _req <- web.middleware(req)
  let body = string_tree.from_string("<h1>Hello, Joe!</h1>")
  wisp.html_response(body, 200)
}
