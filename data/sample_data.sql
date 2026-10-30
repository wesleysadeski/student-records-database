/*
  Sample data. All names, addresses and contact details are fictional
  (from the course case study).

  This insert is the one that forced a redesign: the student is from a
  Canadian school, so the original U.S.-only address columns didn't fit.
  Province and Zip Code were added, and several columns were made NULLable
  because older data sets were missing them.

  Assumes the Race lookup table is already populated (RaceID 2 must exist).
*/

INSERT INTO Students
    (FirstName, LastName, PreferredName, Pronouns,
     Phone, Email, RaceID,
     AddressLine1, AddressLine2, City, Province, [Zip Code], Country,
     Age, Gender, Major, Status)
VALUES
    ('Raymond', 'Johnson', 'Raymond', 'He/Him',
     '416-897-7259', 'RJohnson23@otc.edu', 2,
     '247 Charoless Avenue', 'Apartment 43B', 'Toronto', 'Ontario', 'N8N 0B6', 'Canada',
     23, 'Male', 'Business Administration', 'In Good Standing');
