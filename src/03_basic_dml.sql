SELECT
    EmployeeID,
    FirstName,
    LastName,
    Email,
    JobTitle,
    DepartmentID,
    ManagerID,
    EmploymentStatus
FROM dbo.Employees
ORDER BY EmployeeID;
GO

-- Insert a new employee using SQL Server's IDENTITY-generated EmployeeID

INSERT INTO dbo.Employees (FirstName, LastName, Email, Phone, HireDate, JobTitle, DepartmentID, ManagerID, EmploymentStatus)
VALUES ('Aditya', 'Chauhan', 'aditya.chauhan@enterprise.com', '9876501030', '2026-02-02', 'Junior Data Engineer', 4, 1005, 'Active');
GO
SELECT EmployeeID, FirstName, LastName, Email, JobTitle, DepartmentID, ManagerID, EmploymentStatus
FROM dbo.Employees WHERE Email = 'aditya.chauhan@enterprise.com';
GO

-- Retrieve active employees working in Data & Analytics

SELECT
    EmployeeID,
    FirstName,
    LastName,
    JobTitle,
    HireDate,
    EmploymentStatus
FROM dbo.Employees
WHERE DepartmentID = 4
  AND EmploymentStatus = 'Active'
ORDER BY HireDate;
GO

-- Find active engineers hired from 2021 onward

SELECT
    EmployeeID,
    FirstName,
    LastName,
    JobTitle,
    HireDate,
    DepartmentID
FROM dbo.Employees
WHERE EmploymentStatus = 'Active'
  AND HireDate >= '2021-01-01'
  AND JobTitle LIKE '%Engineer%'
ORDER BY HireDate;
GO

-- Update one employee's job title using the primary key

UPDATE dbo.Employees
SET JobTitle = 'Senior Data Analyst'
WHERE EmployeeID =
(
    SELECT EmployeeID
    FROM dbo.Employees
    WHERE Email = 'simran.kaur@enterprise.com'
);
GO

SELECT
    EmployeeID,
    FirstName,
    LastName,
    JobTitle
FROM dbo.Employees
WHERE Email = 'simran.kaur@enterprise.com';
GO

--  Update an employee's phone number and job title

UPDATE dbo.Employees
SET
    Phone = '9876501099',
    JobTitle = 'Senior Software Engineer'
WHERE Email = 'yash.mishra@enterprise.com';
GO

SELECT
    EmployeeID,
    FirstName,
    LastName,
    Phone,
    JobTitle
FROM dbo.Employees
WHERE Email = 'yash.mishra@enterprise.com';
GO

--Demonstrate a calculated UPDATE while protecting the original data

BEGIN TRANSACTION;

UPDATE dbo.Projects
SET Budget = Budget * 1.10
WHERE ProjectStatus = 'Active';

SELECT
    ProjectID,
    ProjectName,
    Budget AS UpdatedBudget,
    ProjectStatus
FROM dbo.Projects
WHERE ProjectStatus = 'Active'
ORDER BY ProjectID;

ROLLBACK TRANSACTION;
GO

-- Delete one temporary employee using a precise predicate

DELETE FROM dbo.Employees
WHERE Email = 'aditya.chauhan@enterprise.com';
GO

SELECT
    EmployeeID,
    FirstName,
    LastName,
    Email
FROM dbo.Employees
WHERE Email = 'aditya.chauhan@enterprise.com';
GO

-- Demonstrate DELETE safely using a transaction and rollback

BEGIN TRANSACTION;

DELETE FROM dbo.Employees
WHERE EmploymentStatus = 'On Leave';

SELECT
    EmployeeID,
    FirstName,
    LastName,
    EmploymentStatus
FROM dbo.Employees
WHERE EmploymentStatus = 'On Leave';

ROLLBACK TRANSACTION;
GO

-- Demonstrate foreign-key protection when deleting a referenced employee

DELETE FROM dbo.Employees
WHERE EmployeeID = 1005;
GO


