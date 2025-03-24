import database
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn database_test() {
  let assert Ok(db) = database.start()

  db
  |> database.push(1)
  |> database.push(2)
  |> database.push(3)

  db
  |> database.contents
  |> should.equal([3, 2, 1])

  database.stop(db)
}
