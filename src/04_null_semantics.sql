--Identify employees whose manager or department is unknown

USE EmployeeEnterpriseDB;
GO

SELECT
    EmployeeID,
    FirstName,
    LastName,
    JobTitle,
    DepartmentID,
    ManagerID
FROM dbo.Employees
WHERE DepartmentID IS NULL
   OR ManagerID IS NULL
ORDER BY EmployeeID;
GO

--Demonstrate why '= NULL' does not return NULL-valued rows

SELECT
    EmployeeID,
    FirstName,
    LastName,
    ManagerID
FROM dbo.Employees
WHERE ManagerID = NULL;
GO

-- Correctly identify employees without a manager using IS NULL

SELECT
    EmployeeID,
    FirstName,
    LastName,
    JobTitle,
    ManagerID
FROM dbo.Employees
WHERE ManagerID IS NULL
ORDER BY EmployeeID;
GO

--Identify employees whose manager relationship is known

SELECT
    EmployeeID,
    FirstName,
    LastName,
    JobTitle,
    ManagerID
FROM dbo.Employees
WHERE ManagerID IS NOT NULL
ORDER BY ManagerID, EmployeeID;
GO

--Show that 'DepartmentID <> 4' excludes NULL department values

SELECT
    EmployeeID,
    FirstName,
    LastName,
    DepartmentID
FROM dbo.Employees
WHERE DepartmentID <> 4
ORDER BY EmployeeID;
GO

--Include employees outside department 4 as well as employees with unknown departments

SELECT
    EmployeeID,
    FirstName,
    LastName,
    DepartmentID
FROM dbo.Employees
WHERE DepartmentID <> 4
   OR DepartmentID IS NULL
ORDER BY EmployeeID;
GO

--Replace missing phone numbers and departments with readable labels

SELECT
    EmployeeID,
    FirstName,
    LastName,
    COALESCE(Phone, 'Phone Not Available') AS Phone,
    COALESCE(
        CAST(DepartmentID AS VARCHAR(20)),
        'Department Not Assigned'
    ) AS DepartmentID
FROM dbo.Employees
ORDER BY EmployeeID;
GO

--Demonstrate multiple fallback expressions using COALESCE

SELECT
    EmployeeID,
    FirstName,
    LastName,
    COALESCE(
        Phone,
        'No Phone Recorded',
        'Unknown'
    ) AS ContactNumber
FROM dbo.Employees
ORDER BY EmployeeID;
GO

--Demonstrate how aggregate COUNT treats NULL differently

SELECT
    COUNT(*) AS TotalReviewRows,
    COUNT(Rating) AS ReviewsWithRating,
    COUNT(*) - COUNT(Rating) AS ReviewsWithoutRating
FROM dbo.PerformanceReviews;
GO

--Demonstrate how aggregate COUNT treats NULL differently

SELECT
    COUNT(*) AS TotalReviewRows,
    COUNT(Rating) AS ReviewsWithRating,
    COUNT(*) - COUNT(Rating) AS ReviewsWithoutRating
FROM dbo.PerformanceReviews;
GO

-- Demonstrate NULLIF preventing division by zero

SELECT
    100.0 / NULLIF(0, 0) AS SafeDivisionResult;
GO

-- Use NULLIF to convert an empty text value into NULL

SELECT
    EmployeeID,
    FirstName,
    LastName,
    NULLIF(Phone, '') AS NormalizedPhone
FROM dbo.Employees
ORDER BY EmployeeID;
GO

