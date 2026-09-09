USE EmployeeEnterpriseDB;
GO

-- Demonstrate FROM as the initial row source
SELECT EmployeeID, FirstName, LastName, DepartmentID
FROM dbo.Employees;
GO

-- Demonstrate WHERE filtering
SELECT EmployeeID, FirstName, LastName, JobTitle, EmploymentStatus
FROM dbo.Employees
WHERE EmploymentStatus = 'Active'
ORDER BY EmployeeID;
GO

-- Demonstrate ON vs WHERE using LEFT JOIN
SELECT e.EmployeeID, CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName, d.DepartmentName
FROM dbo.Employees AS e
LEFT JOIN dbo.Departments AS d
    ON e.DepartmentID = d.DepartmentID
   AND d.DepartmentName = 'Engineering'
ORDER BY e.EmployeeID;
GO

-- Demonstrate WHERE after LEFT JOIN
SELECT e.EmployeeID, CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName, d.DepartmentName
FROM dbo.Employees AS e
LEFT JOIN dbo.Departments AS d
    ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Engineering'
ORDER BY e.EmployeeID;
GO

-- Demonstrate GROUP BY
SELECT DepartmentID, COUNT(*) AS EmployeeCount
FROM dbo.Employees
GROUP BY DepartmentID
ORDER BY DepartmentID;
GO

-- Demonstrate WHERE before GROUP BY
SELECT DepartmentID, COUNT(*) AS ActiveEmployeeCount
FROM dbo.Employees
WHERE EmploymentStatus = 'Active'
GROUP BY DepartmentID
ORDER BY DepartmentID;
GO

-- Demonstrate HAVING after GROUP BY
SELECT DepartmentID, COUNT(*) AS EmployeeCount
FROM dbo.Employees
GROUP BY DepartmentID
HAVING COUNT(*) >= 3
ORDER BY EmployeeCount DESC;
GO

-- Demonstrate WHERE and HAVING together
SELECT DepartmentID, COUNT(*) AS ActiveEmployeeCount
FROM dbo.Employees
WHERE EmploymentStatus = 'Active'
GROUP BY DepartmentID
HAVING COUNT(*) >= 2
ORDER BY ActiveEmployeeCount DESC;
GO

-- Demonstrate SELECT aliases
SELECT EmployeeID, CONCAT(FirstName, ' ', LastName) AS EmployeeName, HireDate
FROM dbo.Employees
ORDER BY EmployeeName;
GO

-- Demonstrate alias limitation in WHERE
SELECT EmployeeID, CONCAT(FirstName, ' ', LastName) AS EmployeeName
FROM dbo.Employees
WHERE EmployeeName LIKE 'A%';
GO

-- Correct the alias problem
SELECT EmployeeID, CONCAT(FirstName, ' ', LastName) AS EmployeeName
FROM dbo.Employees
WHERE CONCAT(FirstName, ' ', LastName) LIKE 'A%'
ORDER BY EmployeeName;
GO

-- Demonstrate DISTINCT
SELECT DISTINCT DepartmentID
FROM dbo.Employees
ORDER BY DepartmentID;
GO

-- Demonstrate DISTINCT across multiple columns
SELECT DISTINCT DepartmentID, EmploymentStatus
FROM dbo.Employees
ORDER BY DepartmentID, EmploymentStatus;
GO

-- Demonstrate TOP with ORDER BY
SELECT TOP (5) EmployeeID, CONCAT(FirstName, ' ', LastName) AS EmployeeName, JobTitle, HireDate
FROM dbo.Employees
ORDER BY HireDate DESC;
GO

-- Demonstrate TOP WITH TIES
SELECT TOP (3) WITH TIES EmployeeID, CONCAT(FirstName, ' ', LastName) AS EmployeeName, HireDate
FROM dbo.Employees
ORDER BY HireDate DESC;
GO

-- Complete Logical Query Processing Pipeline
SELECT TOP (3) d.DepartmentName, COUNT(e.EmployeeID) AS ActiveEmployeeCount
FROM dbo.Departments AS d
LEFT JOIN dbo.Employees AS e
    ON d.DepartmentID = e.DepartmentID
   AND e.EmploymentStatus = 'Active'
WHERE d.Location IS NOT NULL
GROUP BY d.DepartmentName
HAVING COUNT(e.EmployeeID) >= 2
ORDER BY ActiveEmployeeCount DESC;
GO