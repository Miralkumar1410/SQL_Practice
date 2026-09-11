USE EmployeeEnterpriseDB;
GO

-- ============================================================
-- 1. Identify duplicate groups
-- ============================================================

SELECT
    FirstName,
    LastName,
    DepartmentID,
    COUNT(*) AS DuplicateCount
FROM dbo.Employees
GROUP BY FirstName, LastName, DepartmentID
HAVING COUNT(*) > 1;
GO

-- ============================================================
-- 2. Identify duplicate rows using ROW_NUMBER()
-- ============================================================

WITH DuplicateCheck AS
(
    SELECT
        EmployeeID,
        FirstName,
        LastName,
        DepartmentID,
        Salary,
        ROW_NUMBER() OVER
        (
            PARTITION BY FirstName, LastName, DepartmentID
            ORDER BY EmployeeID
        ) AS rn
    FROM dbo.Employees
)
SELECT *
FROM DuplicateCheck
WHERE rn > 1;
GO

-- ============================================================
-- 3. Keep one record from each duplicate group
-- ============================================================

WITH RankedRows AS
(
    SELECT
        *,
        ROW_NUMBER() OVER
        (
            PARTITION BY FirstName, LastName, DepartmentID
            ORDER BY EmployeeID DESC
        ) AS rn
    FROM dbo.Employees
)
SELECT *
FROM RankedRows
WHERE rn = 1;
GO
