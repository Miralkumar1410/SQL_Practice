USE EmployeeEnterpriseDB;


-- ============================================================
-- COMMON TABLE EXPRESSIONS (CTEs)
-- ============================================================


WITH EmployeeDetails AS
(
    SELECT
        EmployeeID,
        FirstName,
        LastName,
        DepartmentID,
        Salary
    FROM dbo.Employees
)
SELECT *
FROM EmployeeDetails;

-- 3. CTE with Aggregation
-- Calculate the average salary for each department.

WITH DepartmentSalary AS
(
    SELECT
        DepartmentID,
        AVG(Salary) AS AverageSalary
    FROM dbo.Employees
    GROUP BY DepartmentID
)
SELECT
    DepartmentID,
    AverageSalary
FROM DepartmentSalary;

-- 4. CTE with JOIN

WITH DepartmentSalary AS
(
    SELECT
        DepartmentID,
        AVG(Salary) AS AverageSalary
    FROM dbo.Employees
    GROUP BY DepartmentID
)
SELECT
    d.DepartmentName,
    ds.AverageSalary
FROM DepartmentSalary AS ds
INNER JOIN dbo.Departments AS d
    ON ds.DepartmentID = d.DepartmentID;

-- 5. Multiple CTEs

WITH EmployeeCount AS
(
    SELECT
        DepartmentID,
        COUNT(*) AS EmployeeCount
    FROM dbo.Employees
    GROUP BY DepartmentID
),
DepartmentSalary AS
(
    SELECT
        DepartmentID,
        AVG(Salary) AS AverageSalary
    FROM dbo.Employees
    GROUP BY DepartmentID
)
SELECT
    d.DepartmentName,
    ec.EmployeeCount,
    ds.AverageSalary
FROM dbo.Departments AS d
LEFT JOIN EmployeeCount AS ec
    ON d.DepartmentID = ec.DepartmentID
LEFT JOIN DepartmentSalary AS ds
    ON d.DepartmentID = ds.DepartmentID;

-- 6. CTE + Window Function
-- Rank employees by salary within each department.

WITH RankedEmployees AS
(
    SELECT
        EmployeeID,
        FirstName,
        LastName,
        DepartmentID,
        Salary,
        ROW_NUMBER() OVER
        (
            PARTITION BY DepartmentID
            ORDER BY Salary DESC
        ) AS SalaryRank
    FROM dbo.Employees
)
SELECT *
FROM RankedEmployees
WHERE SalaryRank <= 3;
