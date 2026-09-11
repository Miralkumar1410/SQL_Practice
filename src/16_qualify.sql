USE EmployeeEnterpriseDB;
GO


-- ============================================================
-- PART 2: QUALIFY BEHAVIOR IN SQL SERVER
-- ============================================================

-- Return the earliest hired employee from every department.

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
-- 2.2 QUALIFY-like behavior using a subquery
-- ------------------------------------------------------------

SELECT
    EmployeeID,
    EmployeeName,
    DepartmentID,
    HireDate
FROM
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
) AS RankedEmployees
WHERE RowNumber = 1
ORDER BY DepartmentID;
GO

-- ------------------------------------------------------------
-- 2.3 Filter top two employees from every department
-- ------------------------------------------------------------

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
    HireDate,
    RowNumber
FROM RankedEmployees
WHERE RowNumber <= 2
ORDER BY DepartmentID, RowNumber;
GO

-- ------------------------------------------------------------
-- 2.4 Filter the highest-rated employee in each department
-- ------------------------------------------------------------

WITH EmployeeRatings AS
(
    SELECT
        e.EmployeeID,
        CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
        e.DepartmentID,
        AVG(pr.Rating) AS AverageRating
    FROM dbo.Employees AS e
    INNER JOIN dbo.PerformanceReviews AS pr
        ON e.EmployeeID = pr.EmployeeID
    GROUP BY
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.DepartmentID
),
RankedRatings AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        DepartmentID,
        AverageRating,
        RANK() OVER
        (
            PARTITION BY DepartmentID
            ORDER BY AverageRating DESC
        ) AS RatingRank
    FROM EmployeeRatings
)
SELECT
    EmployeeID,
    EmployeeName,
    DepartmentID,
    AverageRating,
    RatingRank
FROM RankedRatings
WHERE RatingRank = 1
ORDER BY DepartmentID;
GO


