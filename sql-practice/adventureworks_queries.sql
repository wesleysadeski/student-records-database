/*
  SQL practice queries against Microsoft's AdventureWorks sample database
  (SQL Server 2022, run in SSMS).

  Covers: filtering, pattern matching, NULL handling, string functions,
  date functions, aggregation, GROUP BY, TOP, and LEFT / RIGHT / INNER joins.
*/

USE AdventureWorks;
GO

---------------------------------------------------------------------------
-- Basics: counting, filtering, sorting
---------------------------------------------------------------------------

-- How many departments are there?  (Result: 16)
SELECT COUNT(*) FROM HumanResources.Department;

-- Number of departments in each department group
SELECT GroupName, COUNT(*) AS RepeatCount
FROM HumanResources.Department
GROUP BY GroupName
ORDER BY GroupName;

-- Pay history records at or below $15.00/hour, highest first
SELECT *
FROM HumanResources.EmployeePayHistory
WHERE Rate <= 15.00
ORDER BY Rate DESC;

-- Addresses in three cities that have a second address line
SELECT *
FROM Person.Address
WHERE City IN ('Portland', 'Seattle', 'Phoenix')
  AND AddressLine2 IS NOT NULL;

-- Product models missing both a catalog description and instructions  (Result: 113)
SELECT COUNT(*)
FROM Production.ProductModel
WHERE CatalogDescription IS NULL
  AND Instructions IS NULL;

-- Red and yellow bikes (product numbers starting with BK), sorted three ways
SELECT ProductNumber, Name, Color, ReorderPoint
FROM Production.Product
WHERE ProductNumber LIKE 'BK%'
  AND Color IN ('Yellow', 'Red')
ORDER BY Color ASC, ProductNumber ASC, Name DESC;

-- Highest-priced order line for one tracking number
SELECT TOP 1 SalesOrderID
FROM Sales.SalesOrderDetail
WHERE CarrierTrackingNumber = '6C2D-4670-B0'
ORDER BY UnitPrice DESC;

---------------------------------------------------------------------------
-- String and date functions
---------------------------------------------------------------------------

-- Strip the domain prefix from login IDs for a specific group of employees:
-- organization level 4, male, high sick or vacation hours, hired in 2009
SELECT REPLACE(LoginID, 'adventure-works\', '') AS UserName
FROM HumanResources.Employee
WHERE OrganizationLevel = 4
  AND Gender = 'M'
  AND (SickLeaveHours > 60 OR VacationHours > 80)
  AND YEAR(HireDate) = 2009;

---------------------------------------------------------------------------
-- Joins
---------------------------------------------------------------------------

-- Individual customers with last names starting with A, plus their email.
-- ISNULL swaps missing middle names and suffixes for blanks.
SELECT FirstName,
       ISNULL(MiddleName, '') AS MiddleName,
       LastName,
       ISNULL(Suffix, '')     AS Suffix
FROM Person.Person
JOIN Person.EmailAddress
    ON Person.BusinessEntityID = EmailAddress.BusinessEntityID
WHERE PersonType = 'IN'
  AND LastName LIKE 'A%'
ORDER BY FirstName;

-- Products that have NEVER been sold.
-- LEFT JOIN keeps every product; rows with no matching order detail come back NULL.
SELECT Product.ProductID, Name, ProductNumber, ListPrice
FROM Production.Product
LEFT JOIN Sales.SalesOrderDetail
    ON Product.ProductID = SalesOrderDetail.ProductID
WHERE ListPrice > 0
  AND SalesOrderDetail.ProductID IS NULL
ORDER BY ListPrice DESC;

-- Every product review with the product it belongs to, newest review first per product
SELECT Product.ProductID, Name, ReviewerName, ReviewDate, EmailAddress
FROM Production.Product
RIGHT JOIN Production.ProductReview
    ON ProductReview.ProductID = Product.ProductID
ORDER BY ProductID, ReviewDate DESC;
