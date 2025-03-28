import app/web
import database
import gleam/dynamic/decode
import gleam/http
import gleam/json
import wisp

pub fn handle_request(
  req: wisp.Request,
  db: database.Database(String),
) -> wisp.Response {
  use req <- web.middleware(req)
  case wisp.path_segments(req) {
    ["todos"] -> handle_todos(req, db)
    _ -> wisp.not_found()
  }
}

fn handle_todos(
  req: wisp.Request,
  db: database.Database(String),
) -> wisp.Response {
  case req.method {
    http.Get -> list_todos(db)
    http.Post -> create_todo(req, db)
    _ -> wisp.method_not_allowed([http.Get, http.Post])
  }
}

fn list_todos(db: database.Database(String)) -> wisp.Response {
  db
  |> database.contents
  |> json.array(of: json.string)
  |> json.to_string_tree
  |> wisp.json_response(200)
}

fn create_todo(
  req: wisp.Request,
  db: database.Database(String),
) -> wisp.Response {
  use body <- wisp.require_json(req)

  case decode.run(body, decode.string) {
    Error(_) -> wisp.bad_request()
    Ok(todo_element) -> {
      database.push(db, todo_element)

      todo_element
      |> json.string
      |> json.to_string_tree
      |> wisp.json_response(201)
    }
  }
}
