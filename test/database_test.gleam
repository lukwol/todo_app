import database
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn database_test() {
  let assert Ok(db) = database.start()

  database.push(db, 1)
  database.push(db, 2)
  database.push(db, 3)

  db
  |> database.contents
  |> should.equal([3, 2, 1])

  database.stop(db)
}
