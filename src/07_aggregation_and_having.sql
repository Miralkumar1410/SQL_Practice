USE EmployeeEnterpriseDB;
GO

-- Calculate overall employee and department statistics
SELECT
    COUNT(*) AS TotalEmployees,
    COUNT(DepartmentID) AS EmployeesWithDepartment,
    COUNT(ManagerID) AS EmployeesWithManager,
    COUNT(DISTINCT DepartmentID) AS DistinctDepartments
FROM dbo.Employees;
GO

-- Calculate the total budget across all enterprise projects
SELECT
    SUM(Budget) AS TotalProjectBudget
FROM dbo.Projects;
GO

-- Calculate minimum, maximum, and average performance ratings
SELECT
    MIN(Rating) AS MinimumRating,
    MAX(Rating) AS MaximumRating,
    AVG(Rating) AS AverageRating
FROM dbo.PerformanceReviews;
GO

-- Count employees in each department
SELECT
    DepartmentID,
    COUNT(*) AS EmployeeCount
FROM dbo.Employees
GROUP BY DepartmentID
ORDER BY DepartmentID;
GO

-- Display department names and their employee counts
SELECT
    d.DepartmentID,
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount
FROM dbo.Departments AS d
LEFT JOIN dbo.Employees AS e
    ON d.DepartmentID = e.DepartmentID
GROUP BY
    d.DepartmentID,
    d.DepartmentName
ORDER BY
    EmployeeCount DESC,
    d.DepartmentID;
GO

-- Count active employees in each department
SELECT
    d.DepartmentName,
    COUNT(e.EmployeeID) AS ActiveEmployeeCount
FROM dbo.Departments AS d
LEFT JOIN dbo.Employees AS e
    ON d.DepartmentID = e.DepartmentID
   AND e.EmploymentStatus = 'Active'
GROUP BY
    d.DepartmentID,
    d.DepartmentName
ORDER BY ActiveEmployeeCount DESC;
GO

-- Filter active employees before calculating department-level counts
SELECT
    DepartmentID,
    COUNT(*) AS ActiveEmployeeCount
FROM dbo.Employees
WHERE EmploymentStatus = 'Active'
GROUP BY DepartmentID
ORDER BY ActiveEmployeeCount DESC;
GO

-- Return only departments containing at least three employees
SELECT
    DepartmentID,
    COUNT(*) AS EmployeeCount
FROM dbo.Employees
GROUP BY DepartmentID
HAVING COUNT(*) >= 3
ORDER BY EmployeeCount DESC;
GO

-- Find departments with at least two active employees
SELECT
    DepartmentID,
    COUNT(*) AS ActiveEmployeeCount
FROM dbo.Employees
WHERE EmploymentStatus = 'Active'
GROUP BY DepartmentID
HAVING COUNT(*) >= 2
ORDER BY ActiveEmployeeCount DESC;
GO

-- Count employees assigned to each project
SELECT
    p.ProjectID,
    p.ProjectName,
    COUNT(ep.EmployeeID) AS AssignedEmployees
FROM dbo.Projects AS p
LEFT JOIN dbo.EmployeeProjects AS ep
    ON p.ProjectID = ep.ProjectID
GROUP BY
    p.ProjectID,
    p.ProjectName
ORDER BY
    AssignedEmployees DESC,
    p.ProjectID;
GO

-- Find projects with at least two assigned employees
SELECT
    p.ProjectID,
    p.ProjectName,
    COUNT(ep.EmployeeID) AS AssignedEmployees
FROM dbo.Projects AS p
LEFT JOIN dbo.EmployeeProjects AS ep
    ON p.ProjectID = ep.ProjectID
GROUP BY
    p.ProjectID,
    p.ProjectName
HAVING COUNT(ep.EmployeeID) >= 2
ORDER BY AssignedEmployees DESC;
GO

-- Calculate each employee's average performance rating
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    AVG(pr.Rating) AS AverageRating,
    COUNT(pr.Rating) AS RatedReviews
FROM dbo.Employees AS e
LEFT JOIN dbo.PerformanceReviews AS pr
    ON e.EmployeeID = pr.EmployeeID
GROUP BY
    e.EmployeeID,
    e.FirstName,
    e.LastName
ORDER BY AverageRating DESC;
GO

-- Find employees whose average rated performance is above 4.0
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    AVG(pr.Rating) AS AverageRating
FROM dbo.Employees AS e
INNER JOIN dbo.PerformanceReviews AS pr
    ON e.EmployeeID = pr.EmployeeID
GROUP BY
    e.EmployeeID,
    e.FirstName,
    e.LastName
HAVING AVG(pr.Rating) > 4.00
ORDER BY AverageRating DESC;
GO

-- Calculate multiple employee-status metrics in one result
SELECT
    COUNT(*) AS TotalEmployees,
    SUM(CASE
        WHEN EmploymentStatus = 'Active' THEN 1
        ELSE 0
    END) AS ActiveEmployees,
    SUM(CASE
        WHEN EmploymentStatus = 'On Leave' THEN 1
        ELSE 0
    END) AS EmployeesOnLeave,
    SUM(CASE
        WHEN DepartmentID IS NULL THEN 1
        ELSE 0
    END) AS UnassignedDepartmentEmployees,
    SUM(CASE
        WHEN ManagerID IS NULL THEN 1
        ELSE 0
    END) AS EmployeesWithoutManagers
FROM dbo.Employees;
GO

-- Produce active, on-leave, and total employee counts per department
SELECT
    d.DepartmentName,
    COUNT(e.EmployeeID) AS TotalEmployees,
    SUM(CASE
        WHEN e.EmploymentStatus = 'Active' THEN 1
        ELSE 0
    END) AS ActiveEmployees,
    SUM(CASE
        WHEN e.EmploymentStatus = 'On Leave' THEN 1
        ELSE 0
    END) AS EmployeesOnLeave
FROM dbo.Departments AS d
LEFT JOIN dbo.Employees AS e
    ON d.DepartmentID = e.DepartmentID
GROUP BY
    d.DepartmentID,
    d.DepartmentName
ORDER BY d.DepartmentName;
GO

-- Calculate project count and total budget for each project status
SELECT
    ProjectStatus,
    COUNT(*) AS ProjectCount,
    SUM(Budget) AS TotalBudget,
    AVG(Budget) AS AverageBudget,
    MIN(Budget) AS MinimumBudget,
    MAX(Budget) AS MaximumBudget
FROM dbo.Projects
GROUP BY ProjectStatus
ORDER BY TotalBudget DESC;
GO

-- Summarize project count and budget by department
SELECT
    d.DepartmentName,
    COUNT(p.ProjectID) AS ProjectCount,
    COALESCE(SUM(p.Budget), 0) AS TotalBudget
FROM dbo.Departments AS d
LEFT JOIN dbo.Projects AS p
    ON d.DepartmentID = p.DepartmentID
GROUP BY
    d.DepartmentID,
    d.DepartmentName
ORDER BY TotalBudget DESC;
GO

-- Compare assignment rows with unique employees
SELECT
    COUNT(*) AS EmployeeProjectRows,
    COUNT(DISTINCT e.EmployeeID) AS UniqueEmployees
FROM dbo.Employees AS e
INNER JOIN dbo.EmployeeProjects AS ep
    ON e.EmployeeID = ep.EmployeeID;
GO

-- Identify managers who have at least two direct reports
SELECT
    m.EmployeeID AS ManagerID,
    CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName,
    COUNT(e.EmployeeID) AS DirectReports
FROM dbo.Employees AS m
INNER JOIN dbo.Employees AS e
    ON e.ManagerID = m.EmployeeID
GROUP BY
    m.EmployeeID,
    m.FirstName,
    m.LastName
HAVING COUNT(e.EmployeeID) >= 2
ORDER BY DirectReports DESC;
GO