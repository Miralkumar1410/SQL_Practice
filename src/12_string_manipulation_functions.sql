USE EmployeeEnterpriseDB;
GO


-- ============================================================
-- PART 5: STRING MANIPULATION FUNCTIONS
-- ============================================================

-- ------------------------------------------------------------
-- 5.1 SUBSTRING
-- ------------------------------------------------------------


SELECT
    EmployeeID,
    FirstName,
    SUBSTRING(FirstName, 1, 3) AS FirstThreeCharacters,
    SUBSTRING(LastName, 1, 2) AS FirstTwoLastNameCharacters
FROM dbo.Employees
ORDER BY EmployeeID;
GO

-- Extract the domain from employee email addresses.

SELECT
    EmployeeID,
    Email,
    SUBSTRING
    (
        Email,
        CHARINDEX('@', Email) + 1,
        LEN(Email)
    ) AS EmailDomain
FROM dbo.Employees
ORDER BY EmployeeID;
GO

-- ------------------------------------------------------------
-- 5.2 CHARINDEX
-- ------------------------------------------------------------

SELECT
    EmployeeID,
    Email,
    CHARINDEX('@', Email) AS AtSymbolPosition
FROM dbo.Employees
ORDER BY EmployeeID;
GO

-- Find employees whose email contains "enterprise".

SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    Email
FROM dbo.Employees
WHERE CHARINDEX('enterprise', Email) > 0
ORDER BY EmployeeID;
GO

-- ------------------------------------------------------------
-- 5.3 STUFF
-- ------------------------------------------------------------

-- Replace the first four digits of a phone number.

SELECT
    EmployeeID,
    Phone,
    STUFF(Phone, 1, 4, 'XXXX') AS MaskedPhone
FROM dbo.Employees
WHERE Phone IS NOT NULL
ORDER BY EmployeeID;
GO

-- Change the email domain for demonstration purposes.

SELECT
    EmployeeID,
    Email,
    STUFF
    (
        Email,
        CHARINDEX('@', Email),
        LEN(Email),
        '@example.com'
    ) AS ExampleEmail
FROM dbo.Employees
ORDER BY EmployeeID;
GO

-- ------------------------------------------------------------
-- 5.4 CONCAT_WS
-- ------------------------------------------------------------

SELECT
    EmployeeID,
    CONCAT_WS
    (
        ' ',
        FirstName,
        LastName
    ) AS EmployeeName
FROM dbo.Employees
ORDER BY EmployeeID;
GO

SELECT
    EmployeeID,
    CONCAT_WS
    (
        ', ',
        FirstName,
        LastName,
        JobTitle
    ) AS EmployeeDetails
FROM dbo.Employees
ORDER BY EmployeeID;
GO

-- Build an employee location-style label.

SELECT
    e.EmployeeID,
    CONCAT_WS
    (
        ' - ',
        CONCAT(e.FirstName, ' ', e.LastName),
        d.DepartmentName,
        d.Location
    ) AS EmployeeDepartmentLocation
FROM dbo.Employees AS e
LEFT JOIN dbo.Departments AS d
    ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID;
GO

-- ------------------------------------------------------------
-- 5.5 STRING_AGG
-- ------------------------------------------------------------


-- List employees belonging to each department.

SELECT
    d.DepartmentName,
    STRING_AGG
    (
        CONCAT(e.FirstName, ' ', e.LastName),
        ', '
    ) AS Employees
FROM dbo.Departments AS d
LEFT JOIN dbo.Employees AS e
    ON d.DepartmentID = e.DepartmentID
GROUP BY
    d.DepartmentID,
    d.DepartmentName
ORDER BY d.DepartmentName;
GO

-- List project roles assigned to each project.

SELECT
    p.ProjectName,
    STRING_AGG(ep.ProjectRole, ', ') AS ProjectRoles
FROM dbo.Projects AS p
INNER JOIN dbo.EmployeeProjects AS ep
    ON p.ProjectID = ep.ProjectID
GROUP BY
    p.ProjectID,
    p.ProjectName
ORDER BY p.ProjectID;
GO

-- ------------------------------------------------------------
-- 5.6 LIKE and PATINDEX pattern matching
-- ------------------------------------------------------------

-- Find names starting with A.

SELECT
    EmployeeID,
    FirstName,
    LastName
FROM dbo.Employees
WHERE FirstName LIKE 'A%'
ORDER BY FirstName;
GO

-- Find job titles containing "Engineer".

SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    JobTitle
FROM dbo.Employees
WHERE JobTitle LIKE '%Engineer%'
ORDER BY EmployeeID;
GO

-- Find first names containing the letter "a".

SELECT
    EmployeeID,
    FirstName
FROM dbo.Employees
WHERE PATINDEX('%a%', FirstName) > 0
ORDER BY FirstName;
GO

-- Find names beginning with A or P.

SELECT
    EmployeeID,
    FirstName,
    LastName
FROM dbo.Employees
WHERE FirstName LIKE '[AP]%'
ORDER BY FirstName;
GO

-- ------------------------------------------------------------
-- 5.7 Regular expressions in SQL Server 2025
-- ------------------------------------------------------------


-- Check the current database compatibility level.

SELECT
    name AS DatabaseName,
    compatibility_level
FROM sys.databases
WHERE name = DB_NAME();
GO
