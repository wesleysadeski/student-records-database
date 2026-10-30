/*
  Student Records Database - table definitions (Microsoft SQL Server / T-SQL)

  Final version of the design. Six tables:
    Race                 lookup table shared by Students and Faculty
    Students             one row per student, including preferred name and pronouns
    Faculty              one row per instructor or staff member
    Courses              course catalog
    Enrollments          which student took which course, in which term, with what grade
    StudentInteractions  log of meetings and notes between staff and a student

  Note: this script was rebuilt from the final database diagram and the INSERT
  statements used in the project. Column sizes are reasonable defaults.
*/

CREATE TABLE Race (
    RaceID      INT IDENTITY(1,1) PRIMARY KEY,
    RaceName    VARCHAR(50) NOT NULL
);

CREATE TABLE Students (
    StudentID      INT IDENTITY(1,1) PRIMARY KEY,
    FirstName      VARCHAR(50)  NOT NULL,
    LastName       VARCHAR(50)  NOT NULL,
    PreferredName  VARCHAR(50)  NULL,
    Pronouns       VARCHAR(20)  NULL,
    Phone          VARCHAR(20)  NULL,
    Email          VARCHAR(100) NULL,
    RaceID         INT          NULL,
    AddressLine1   VARCHAR(100) NULL,
    AddressLine2   VARCHAR(100) NULL,   -- optional: apartment, unit, etc.
    City           VARCHAR(50)  NULL,
    Province       VARCHAR(50)  NULL,   -- state or province, so non-U.S. addresses fit
    [Zip Code]     VARCHAR(10)  NULL,   -- VARCHAR, not INT: Canadian postal codes contain letters
    Country        VARCHAR(50)  NULL,
    Age            INT          NULL,
    Gender         VARCHAR(20)  NULL,
    Major          VARCHAR(100) NULL,
    Status         VARCHAR(50)  NULL,
    CONSTRAINT FK_Students_Race FOREIGN KEY (RaceID) REFERENCES Race(RaceID)
);

CREATE TABLE Faculty (
    FacultyID   INT IDENTITY(1,1) PRIMARY KEY,
    FirstName   VARCHAR(50)  NOT NULL,
    LastName    VARCHAR(50)  NOT NULL,
    Email       VARCHAR(100) NULL,
    Phone       VARCHAR(20)  NULL,
    RaceID      INT          NULL,
    Office      VARCHAR(50)  NULL,
    CONSTRAINT FK_Faculty_Race FOREIGN KEY (RaceID) REFERENCES Race(RaceID)
);

CREATE TABLE Courses (
    CourseID    INT IDENTITY(1,1) PRIMARY KEY,
    CourseName  VARCHAR(100) NOT NULL,
    Credits     INT          NOT NULL,
    Department  VARCHAR(100) NULL
);

-- Historical record of every course a student has taken.
-- GPA is NOT stored anywhere; it is calculated from LetterGrade and Credits when needed.
CREATE TABLE Enrollments (
    EnrollmentID  INT IDENTITY(1,1) PRIMARY KEY,
    StudentID     INT        NOT NULL,
    CourseID      INT        NOT NULL,
    LetterGrade   VARCHAR(2) NULL,
    Term          VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Enrollments_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT FK_Enrollments_Courses  FOREIGN KEY (CourseID)  REFERENCES Courses(CourseID)
);

-- Added after reviewing requirements: administrators need to log
-- meetings with students, who they met with, and notes.
CREATE TABLE StudentInteractions (
    InteractionID        INT IDENTITY(1,1) PRIMARY KEY,
    StudentID            INT          NOT NULL,
    InteractionDateTime  DATETIME     NOT NULL,
    StaffName            VARCHAR(100) NOT NULL,
    Notes                VARCHAR(MAX) NULL,
    CONSTRAINT FK_StudentInteractions_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);
