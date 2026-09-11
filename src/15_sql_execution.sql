USE EmployeeEnterpriseDB;
GO


-- ============================================================
-- 1. Logical query processing order
-- ============================================================

-- FROM / JOIN
-- WHERE
-- GROUP BY
-- HAVING
-- SELECT
-- DISTINCT
-- ORDER BY
-- TOP / OFFSET-FETCH

SELECT
    DepartmentID,
    COUNT(*) AS EmployeeCount
FROM dbo.Employees
WHERE Salary IS NOT NULL
GROUP BY DepartmentID
HAVING COUNT(*) >= 1
ORDER BY DepartmentID;
GO

-- ============================================================
-- 2. SELECT aliases and execution order
-- ============================================================

SELECT *
FROM
(
    SELECT
        EmployeeID,
        Salary AS EmployeeSalary
    FROM dbo.Employees
) AS x
WHERE EmployeeSalary > 50000;
GO

-- ============================================================
-- 3. Execution plan in SQL Server
-- ============================================================

SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    d.DepartmentName
FROM dbo.Employees AS e
INNER JOIN dbo.Departments AS d
    ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 50000;
GO
