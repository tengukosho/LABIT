-- Create Department table
CREATE TABLE Department (
    DepartmentID INTEGER PRIMARY KEY AUTOINCREMENT,
    DepartmentName TEXT NOT NULL
);

-- Create Lecturer table
CREATE TABLE Lecturer (
    LecturerID INTEGER PRIMARY KEY AUTOINCREMENT,
    LecturerName TEXT NOT NULL
);

-- Create Course table
CREATE TABLE Course (
    CourseID INTEGER PRIMARY KEY AUTOINCREMENT,
    CourseName TEXT NOT NULL
);

-- Create Student table
CREATE TABLE Student (
    StudentID INTEGER PRIMARY KEY AUTOINCREMENT,
    StudentName TEXT NOT NULL,
    DoB DATE,
    Major TEXT
);

-- Relationship: Register (Student ↔ Course)
CREATE TABLE Register (
    StudentID INTEGER,
    CourseID INTEGER,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Relationship: Teach (Lecturer ↔ Course)
CREATE TABLE Teach (
    LecturerID INTEGER,
    CourseID INTEGER,
    PRIMARY KEY (LecturerID, CourseID),
    FOREIGN KEY (LecturerID) REFERENCES Lecturer(LecturerID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Relationship: Belong (Lecturer ↔ Department)
CREATE TABLE Belong (
    LecturerID INTEGER,
    DepartmentID INTEGER,
    PRIMARY KEY (LecturerID, DepartmentID),
    FOREIGN KEY (LecturerID) REFERENCES Lecturer(LecturerID),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);
