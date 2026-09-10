USE EmployeeEnterpriseDB;

-- ============================================================
--  SUBQUERIES
-- ============================================================


SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    (SELECT AVG(Salary) FROM dbo.Employees) AS AverageSalary
FROM dbo.Employees;

-- 3. Subquery with WHERE
-- Find employees earning more than the company average.

SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary
FROM dbo.Employees
WHERE Salary > (
    SELECT AVG(Salary)
    FROM dbo.Employees
);

-- 4. Subquery with IN
-- Find employees who belong to departments located in a chosen location.
-- Adjust the condition/columns if your Departments table uses different attributes.

SELECT
    EmployeeID,
    FirstName,
    LastName,
    DepartmentID
FROM dbo.Employees
WHERE DepartmentID IN
(
    SELECT DepartmentID
    FROM dbo.Departments
);

-- 5. Correlated Subquery
-- The inner query refers to the current row of the outer query.

SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.DepartmentID,
    e.Salary
FROM dbo.Employees AS e
WHERE e.Salary >
(
    SELECT AVG(e2.Salary)
    FROM dbo.Employees AS e2
    WHERE e2.DepartmentID = e.DepartmentID
);

-- 6. EXISTS
-- EXISTS checks whether the subquery returns at least one row.

SELECT
    d.DepartmentID,
    d.DepartmentName
FROM dbo.Departments AS d
WHERE EXISTS
(
    SELECT 1
    FROM dbo.Employees AS e
    WHERE e.DepartmentID = d.DepartmentID
);

-- 7. NOT EXISTS
-- Find departments with no employees.

SELECT
    d.DepartmentID,
    d.DepartmentName
FROM dbo.Departments AS d
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Employees AS e
    WHERE e.DepartmentID = d.DepartmentID
);

-- 8. Subquery in FROM
-- A subquery used in FROM is commonly called a derived table.

SELECT
    DepartmentID,
    AverageSalary
FROM
(
    SELECT
        DepartmentID,
        AVG(Salary) AS AverageSalary
    FROM dbo.Employees
    GROUP BY DepartmentID
) AS dept_summary;

-- 9. Subquery in HAVING

SELECT
    DepartmentID,
    AVG(Salary) AS AverageSalary
FROM dbo.Employees
GROUP BY DepartmentID
HAVING AVG(Salary) >
(
    SELECT AVG(Salary)
    FROM dbo.Employees
);

