/*
  Reporting queries used to check that each table holds and returns data correctly.
*/

-- All student records
SELECT * FROM Students;

-- Every faculty member and their basic information
SELECT * FROM Faculty;

-- All courses, including credits and department
SELECT * FROM Courses;

-- All enrollments, including letter grades and term (the basis for transcripts)
SELECT * FROM Enrollments;

-- Logged student interactions: staff name, notes, and timestamp
SELECT * FROM StudentInteractions;
