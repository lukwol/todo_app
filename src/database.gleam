import gleam/erlang/process.{type Subject}
import gleam/list
import gleam/otp/actor

pub type Database(element) =
  Subject(Message(element))

pub opaque type Message(e) {
  Shutdown
  Push(push: e)
  Contents(reply: Subject(List(e)))
}

fn handle_message(
  message: Message(e),
  stack: List(e),
) -> actor.Next(Message(e), List(e)) {
  case message {
    Shutdown -> actor.Stop(process.Normal)
    Push(value) -> {
      list.prepend(stack, value)
      |> actor.continue
    }
    Contents(client) -> {
      process.send(client, stack)
      actor.continue(stack)
    }
  }
}

/// Creates a new stack actor
pub fn start() -> Result(Database(e), actor.StartError) {
  actor.start([], handle_message)
}

/// Pushes a value onto the stack
pub fn push(stack: Database(e), value: e) -> Subject(Message(e)) {
  process.send(stack, Push(value))
  stack
}

/// Gets all elements from the stack
pub fn contents(stack: Database(e)) -> List(e) {
  process.call(stack, Contents, 10)
}

/// Stops the stack actor
pub fn stop(stack: Database(e)) {
  process.send(stack, Shutdown)
}
