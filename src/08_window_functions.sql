USE EmployeeEnterpriseDB;
GO

-- 1.1 ROW_NUMBER


-- Give every employee a unique row number ordered by hire date.

SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    HireDate,
    ROW_NUMBER() OVER (ORDER BY HireDate) AS RowNumber
FROM dbo.Employees
ORDER BY HireDate;
GO

-- Restart the row number for every department.

SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    DepartmentID,
    HireDate,
    ROW_NUMBER() OVER
    (
        PARTITION BY DepartmentID
        ORDER BY HireDate
    ) AS DepartmentRowNumber
FROM dbo.Employees
ORDER BY DepartmentID, HireDate;
GO

-- Find the first employee hired in each department.

WITH RankedEmployees AS
(
    SELECT
        EmployeeID,
        CONCAT(FirstName, ' ', LastName) AS EmployeeName,
        DepartmentID,
        HireDate,
        ROW_NUMBER() OVER
        (
            PARTITION BY DepartmentID
            ORDER BY HireDate, EmployeeID
        ) AS RowNumber
    FROM dbo.Employees
)
SELECT
    EmployeeID,
    EmployeeName,
    DepartmentID,
    HireDate
FROM RankedEmployees
WHERE RowNumber = 1
ORDER BY DepartmentID;
GO

-- ------------------------------------------------------------
-- 1.2 RANK
-- ------------------------------------------------------------


SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    AVG(pr.Rating) AS AverageRating,
    RANK() OVER
    (
        ORDER BY AVG(pr.Rating) DESC
    ) AS RatingRank
FROM dbo.Employees AS e
INNER JOIN dbo.PerformanceReviews AS pr
    ON e.EmployeeID = pr.EmployeeID
GROUP BY
    e.EmployeeID,
    e.FirstName,
    e.LastName
ORDER BY RatingRank, EmployeeName;
GO

-- Rank employees separately inside each department.

SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    e.DepartmentID,
    AVG(pr.Rating) AS AverageRating,
    RANK() OVER
    (
        PARTITION BY e.DepartmentID
        ORDER BY AVG(pr.Rating) DESC
    ) AS DepartmentRatingRank
FROM dbo.Employees AS e
INNER JOIN dbo.PerformanceReviews AS pr
    ON e.EmployeeID = pr.EmployeeID
GROUP BY
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.DepartmentID
ORDER BY e.DepartmentID, DepartmentRatingRank;
GO

-- ------------------------------------------------------------
-- 1.3 DENSE_RANK
-- ------------------------------------------------------------

SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    AVG(pr.Rating) AS AverageRating,
    DENSE_RANK() OVER
    (
        ORDER BY AVG(pr.Rating) DESC
    ) AS DenseRatingRank
FROM dbo.Employees AS e
INNER JOIN dbo.PerformanceReviews AS pr
    ON e.EmployeeID = pr.EmployeeID
GROUP BY
    e.EmployeeID,
    e.FirstName,
    e.LastName
ORDER BY DenseRatingRank, EmployeeName;
GO

-- Compare RANK and DENSE_RANK.

SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    AVG(pr.Rating) AS AverageRating,
    RANK() OVER
    (
        ORDER BY AVG(pr.Rating) DESC
    ) AS RatingRank,
    DENSE_RANK() OVER
    (
        ORDER BY AVG(pr.Rating) DESC
    ) AS DenseRatingRank
FROM dbo.Employees AS e
INNER JOIN dbo.PerformanceReviews AS pr
    ON e.EmployeeID = pr.EmployeeID
GROUP BY
    e.EmployeeID,
    e.FirstName,
    e.LastName
ORDER BY AverageRating DESC;
GO

-- ------------------------------------------------------------
-- 1.4 NTILE
-- ------------------------------------------------------------

SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    HireDate,
    NTILE(4) OVER
    (
        ORDER BY HireDate
    ) AS HireDateQuartile
FROM dbo.Employees
ORDER BY HireDate;
GO

-- Divide employees into three groups based on EmployeeID.

SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    NTILE(3) OVER
    (
        ORDER BY EmployeeID
    ) AS EmployeeGroup
FROM dbo.Employees
ORDER BY EmployeeID;
GO

-- ------------------------------------------------------------
-- 1.5 Aggregate Functions with OVER
-- ------------------------------------------------------------

-- Show total project budget on every project row.

SELECT
    ProjectID,
    ProjectName,
    Budget,
    SUM(Budget) OVER () AS TotalProjectBudget
FROM dbo.Projects
ORDER BY ProjectID;
GO

-- Show department budget total beside every project.

SELECT
    ProjectID,
    ProjectName,
    DepartmentID,
    Budget,
    SUM(Budget) OVER
    (
        PARTITION BY DepartmentID
    ) AS DepartmentProjectBudget
FROM dbo.Projects
ORDER BY DepartmentID, ProjectID;
GO

-- Show department employee count beside every employee.

SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    DepartmentID,
    COUNT(*) OVER
    (
        PARTITION BY DepartmentID
    ) AS DepartmentEmployeeCount
FROM dbo.Employees
ORDER BY DepartmentID, EmployeeID;
GO

-- Calculate a running project budget ordered by start date.

SELECT
    ProjectID,
    ProjectName,
    StartDate,
    Budget,
    SUM(Budget) OVER
    (
        ORDER BY StartDate, ProjectID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningBudget
FROM dbo.Projects
ORDER BY StartDate, ProjectID;
GO

-- Calculate department average budget without collapsing project rows.

SELECT
    ProjectID,
    ProjectName,
    DepartmentID,
    Budget,
    AVG(Budget) OVER
    (
        PARTITION BY DepartmentID
    ) AS DepartmentAverageBudget
FROM dbo.Projects
ORDER BY DepartmentID, ProjectID;
GO

-- ------------------------------------------------------------
-- 1.6 LAG
-- ------------------------------------------------------------


SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    HireDate,
    LAG(HireDate) OVER
    (
        ORDER BY HireDate, EmployeeID
    ) AS PreviousHireDate
FROM dbo.Employees
ORDER BY HireDate, EmployeeID;
GO

-- Calculate the number of days between an employee and
-- the employee hired immediately before them.

SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    HireDate,
    LAG(HireDate) OVER
    (
        ORDER BY HireDate, EmployeeID
    ) AS PreviousHireDate,
    DATEDIFF
    (
        DAY,
        LAG(HireDate) OVER
        (
            ORDER BY HireDate, EmployeeID
        ),
        HireDate
    ) AS DaysFromPreviousHire
FROM dbo.Employees
ORDER BY HireDate, EmployeeID;
GO

-- ------------------------------------------------------------
-- 1.7 LEAD
-- ------------------------------------------------------------

SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    HireDate,
    LEAD(HireDate) OVER
    (
        ORDER BY HireDate, EmployeeID
    ) AS NextHireDate
FROM dbo.Employees
ORDER BY HireDate, EmployeeID;
GO

-- Show the next project start date.

SELECT
    ProjectID,
    ProjectName,
    StartDate,
    LEAD(StartDate) OVER
    (
        ORDER BY StartDate, ProjectID
    ) AS NextProjectStartDate
FROM dbo.Projects
ORDER BY StartDate, ProjectID;
GO

-- ------------------------------------------------------------
-- 1.8 FIRST_VALUE
-- ------------------------------------------------------------


SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    DepartmentID,
    HireDate,
    FIRST_VALUE(HireDate) OVER
    (
        PARTITION BY DepartmentID
        ORDER BY HireDate, EmployeeID
    ) AS FirstHireDateInDepartment
FROM dbo.Employees
ORDER BY DepartmentID, HireDate;
GO

-- Show the first employee name in each department.

SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    DepartmentID,
    FIRST_VALUE
    (
        CONCAT(FirstName, ' ', LastName)
    ) OVER
    (
        PARTITION BY DepartmentID
        ORDER BY HireDate, EmployeeID
    ) AS FirstEmployeeInDepartment
FROM dbo.Employees
ORDER BY DepartmentID, HireDate;
GO

-- ------------------------------------------------------------
-- 1.9 LAST_VALUE
-- ------------------------------------------------------------

SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    DepartmentID,
    HireDate,
    LAST_VALUE(HireDate) OVER
    (
        PARTITION BY DepartmentID
        ORDER BY HireDate, EmployeeID
        ROWS BETWEEN UNBOUNDED PRECEDING
             AND UNBOUNDED FOLLOWING
    ) AS LastHireDateInDepartment
FROM dbo.Employees
ORDER BY DepartmentID, HireDate;
GO

-- Compare the default LAST_VALUE frame with the complete frame.

SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    HireDate,
    LAST_VALUE(HireDate) OVER
    (
        ORDER BY HireDate, EmployeeID
    ) AS DefaultLastValue,
    LAST_VALUE(HireDate) OVER
    (
        ORDER BY HireDate, EmployeeID
        ROWS BETWEEN UNBOUNDED PRECEDING
             AND UNBOUNDED FOLLOWING
    ) AS ActualLastValue
FROM dbo.Employees
ORDER BY HireDate, EmployeeID;
GO
