require_relative "../config/environment.rb"


class Student
  attr_accessor :name, :grade, :id


  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    DB[:conn].execute(
      "CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )"
    )
  end

  def self.drop_table
    DB[:conn].execute(
      "DROP TABLE students"
    )
  end

  def save
    if self.id
      self.update
    else
      DB[:conn].execute(
        "INSERT INTO students (name, grade)
        VALUES ( ?, ? )", self.name, self.grade
      )
      self.id = DB[:conn].execute(
        "SELECT last_insert_rowid() FROM students"
      )[0][0]
    end
  end

  def update
    DB[:conn].execute(
      "UPDATE students
      SET name = ?, grade = ?
      WHERE id = ?", [self.name, self.grade, self.id]
    )
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
  end

  def self.new_from_db(row)
    Student.new(row[0], row[1], row[2])
  end

  def self.find_by_name(name)
    row = DB[:conn].execute(
      "SELECT * FROM students
      WHERE name = ?", name
    )[0]
    Student.new(row[0], row[1], row[2])
  end
end
