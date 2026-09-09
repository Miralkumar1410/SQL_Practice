USE EmployeeEnterpriseDB;
GO

-- Display employees who have a matching department
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    e.JobTitle,
    d.DepartmentName,
    d.Location
FROM dbo.Employees AS e
INNER JOIN dbo.Departments AS d
    ON e.DepartmentID = d.DepartmentID
ORDER BY d.DepartmentName, e.EmployeeID;
GO

-- Display every employee, including employees without a department
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    e.JobTitle,
    e.DepartmentID,
    d.DepartmentName,
    d.Location
FROM dbo.Employees AS e
LEFT JOIN dbo.Departments AS d
    ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID;
GO

-- Identify employees that currently have no department assignment
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    e.JobTitle,
    e.DepartmentID
FROM dbo.Employees AS e
LEFT JOIN dbo.Departments AS d
    ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentID IS NULL
ORDER BY e.EmployeeID;
GO

-- Demonstrate RIGHT JOIN and preserve every department
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    d.DepartmentID,
    d.DepartmentName
FROM dbo.Employees AS e
RIGHT JOIN dbo.Departments AS d
    ON e.DepartmentID = d.DepartmentID
ORDER BY d.DepartmentID, e.EmployeeID;
GO

-- Rewrite the RIGHT JOIN as a LEFT JOIN
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    d.DepartmentID,
    d.DepartmentName
FROM dbo.Departments AS d
LEFT JOIN dbo.Employees AS e
    ON d.DepartmentID = e.DepartmentID
ORDER BY d.DepartmentID, e.EmployeeID;
GO

-- Display matched and unmatched records on both sides
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    d.DepartmentID,
    d.DepartmentName,
    CASE
        WHEN e.EmployeeID IS NULL THEN 'Department Without Employee'
        WHEN d.DepartmentID IS NULL THEN 'Employee Without Department'
        ELSE 'Matched'
    END AS RelationshipStatus
FROM dbo.Employees AS e
FULL OUTER JOIN dbo.Departments AS d
    ON e.DepartmentID = d.DepartmentID
ORDER BY RelationshipStatus, d.DepartmentID, e.EmployeeID;
GO

-- Demonstrate a controlled Cartesian product
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    p.ProjectID,
    p.ProjectName
FROM
(
    SELECT TOP (3)
        EmployeeID,
        FirstName,
        LastName
    FROM dbo.Employees
    ORDER BY EmployeeID
) AS e
CROSS JOIN
(
    SELECT TOP (3)
        ProjectID,
        ProjectName
    FROM dbo.Projects
    ORDER BY ProjectID
) AS p
ORDER BY e.EmployeeID, p.ProjectID;
GO

-- Display each employee alongside their manager
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    e.JobTitle,
    e.ManagerID,
    CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName,
    m.JobTitle AS ManagerJobTitle
FROM dbo.Employees AS e
LEFT JOIN dbo.Employees AS m
    ON e.ManagerID = m.EmployeeID
ORDER BY e.EmployeeID;
GO

-- Find employees reporting directly to Priya Sharma
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    e.JobTitle,
    CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName
FROM dbo.Employees AS e
INNER JOIN dbo.Employees AS m
    ON e.ManagerID = m.EmployeeID
WHERE m.Email = 'priya.sharma@enterprise.com'
ORDER BY e.EmployeeID;
GO

-- Identify employees at the top of the reporting hierarchy
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    e.JobTitle,
    e.ManagerID
FROM dbo.Employees AS e
LEFT JOIN dbo.Employees AS m
    ON e.ManagerID = m.EmployeeID
WHERE m.EmployeeID IS NULL
ORDER BY e.EmployeeID;
GO

-- Display employees and their assigned projects
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    ep.ProjectID,
    p.ProjectName,
    ep.ProjectRole,
    ep.AssignmentStatus
FROM dbo.Employees AS e
INNER JOIN dbo.EmployeeProjects AS ep
    ON e.EmployeeID = ep.EmployeeID
INNER JOIN dbo.Projects AS p
    ON ep.ProjectID = p.ProjectID
ORDER BY e.EmployeeID, p.ProjectID;
GO

-- Identify employees without project assignments
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    e.JobTitle
FROM dbo.Employees AS e
LEFT JOIN dbo.EmployeeProjects AS ep
    ON e.EmployeeID = ep.EmployeeID
WHERE ep.EmployeeID IS NULL
ORDER BY e.EmployeeID;
GO

-- Identify projects without employee assignments
SELECT
    p.ProjectID,
    p.ProjectName,
    p.ProjectStatus,
    p.Budget
FROM dbo.Projects AS p
LEFT JOIN dbo.EmployeeProjects AS ep
    ON p.ProjectID = ep.ProjectID
WHERE ep.ProjectID IS NULL
ORDER BY p.ProjectID;
GO

-- Combine employees, projects, and departments
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    e.JobTitle,
    p.ProjectID,
    p.ProjectName,
    p.ProjectStatus,
    d.DepartmentName AS ProjectDepartment,
    ep.ProjectRole,
    ep.AssignmentStatus
FROM dbo.Employees AS e
INNER JOIN dbo.EmployeeProjects AS ep
    ON e.EmployeeID = ep.EmployeeID
INNER JOIN dbo.Projects AS p
    ON ep.ProjectID = p.ProjectID
LEFT JOIN dbo.Departments AS d
    ON p.DepartmentID = d.DepartmentID
ORDER BY p.ProjectID, e.EmployeeID;
GO

-- Demonstrate that a condition in ON preserves non-matching employees
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    d.DepartmentName
FROM dbo.Employees AS e
LEFT JOIN dbo.Departments AS d
    ON e.DepartmentID = d.DepartmentID
   AND d.DepartmentName = 'Engineering'
ORDER BY e.EmployeeID;
GO

-- Demonstrate that moving the condition to WHERE filters rows
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    d.DepartmentName
FROM dbo.Employees AS e
LEFT JOIN dbo.Departments AS d
    ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Engineering'
ORDER BY e.EmployeeID;
GO

-- Show how multiple project assignments create multiple rows
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    ep.ProjectID,
    p.ProjectName
FROM dbo.Employees AS e
INNER JOIN dbo.EmployeeProjects AS ep
    ON e.EmployeeID = ep.EmployeeID
INNER JOIN dbo.Projects AS p
    ON ep.ProjectID = p.ProjectID
WHERE e.EmployeeID = 1008
ORDER BY ep.ProjectID;
GO

-- Demonstrate COUNT(*) and COUNT(DISTINCT)
SELECT
    COUNT(*) AS EmployeeProjectRows,
    COUNT(DISTINCT e.EmployeeID) AS DistinctEmployees
FROM dbo.Employees AS e
INNER JOIN dbo.EmployeeProjects AS ep
    ON e.EmployeeID = ep.EmployeeID;
GO

-- Display employees alongside their performance reviews
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    e.JobTitle,
    pr.ReviewDate,
    pr.Rating,
    pr.ReviewerComments
FROM dbo.Employees AS e
LEFT JOIN dbo.PerformanceReviews AS pr
    ON e.EmployeeID = pr.EmployeeID
ORDER BY e.EmployeeID, pr.ReviewDate;
GO