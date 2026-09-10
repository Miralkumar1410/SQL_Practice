USE EmployeeEnterpriseDB;
GO


-- ============================================================
--  DATE AND TIME FUNCTIONS
-- ============================================================

-- ------------------------------------------------------------
-- 4.1 DATEPART
-- ------------------------------------------------------------


SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    HireDate,
    DATEPART(YEAR, HireDate) AS HireYear,
    DATEPART(QUARTER, HireDate) AS HireQuarter,
    DATEPART(MONTH, HireDate) AS HireMonth,
    DATEPART(DAY, HireDate) AS HireDay
FROM dbo.Employees
ORDER BY HireDate;
GO

-- Group employees by hire year.

SELECT
    DATEPART(YEAR, HireDate) AS HireYear,
    COUNT(*) AS EmployeeCount
FROM dbo.Employees
GROUP BY DATEPART(YEAR, HireDate)
ORDER BY HireYear;
GO

-- ------------------------------------------------------------
-- 4.2 DATEDIFF
-- ------------------------------------------------------------


SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    HireDate,
    DATEDIFF(DAY, HireDate, CAST(GETDATE() AS DATE)) AS DaysSinceHire,
    DATEDIFF(YEAR, HireDate, CAST(GETDATE() AS DATE)) AS YearBoundariesSinceHire
FROM dbo.Employees
ORDER BY HireDate;
GO

-- Calculate project duration where an end date exists.

SELECT
    ProjectID,
    ProjectName,
    StartDate,
    EndDate,
    DATEDIFF(DAY, StartDate, EndDate) AS ProjectDurationDays
FROM dbo.Projects
WHERE EndDate IS NOT NULL
ORDER BY ProjectID;
GO

-- Find employees hired in the last five calendar years.

SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    HireDate
FROM dbo.Employees
WHERE HireDate >= DATEADD(YEAR, -5, CAST(GETDATE() AS DATE))
ORDER BY HireDate DESC;
GO

-- ------------------------------------------------------------
-- 4.3 DATEADD
-- ------------------------------------------------------------



SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    HireDate,
    DATEADD(YEAR, 1, HireDate) AS OneYearAnniversary,
    DATEADD(MONTH, 6, HireDate) AS SixMonthDate,
    DATEADD(DAY, 30, HireDate) AS ThirtyDaysLater
FROM dbo.Employees
ORDER BY HireDate;
GO

-- Find the date one month after each project starts.

SELECT
    ProjectID,
    ProjectName,
    StartDate,
    DATEADD(MONTH, 1, StartDate) AS OneMonthAfterStart
FROM dbo.Projects
ORDER BY StartDate;
GO

-- ------------------------------------------------------------
-- 4.4 EOMONTH
-- ------------------------------------------------------------



SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    HireDate,
    EOMONTH(HireDate) AS HireMonthEnd,
    EOMONTH(HireDate, 1) AS NextMonthEnd
FROM dbo.Employees
ORDER BY HireDate;
GO

-- First and last day of the month.

SELECT
    HireDate,
    DATEFROMPARTS(
        YEAR(HireDate),
        MONTH(HireDate),
        1
    ) AS MonthStart,
    EOMONTH(HireDate) AS MonthEnd
FROM dbo.Employees
ORDER BY HireDate;
GO

-- ------------------------------------------------------------
-- 4.5 FORMAT
-- ------------------------------------------------------------


SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    HireDate,
    FORMAT(HireDate, 'dd-MMM-yyyy') AS FormattedHireDate,
    FORMAT(HireDate, 'MMMM yyyy') AS HireMonth
FROM dbo.Employees
ORDER BY HireDate;
GO

-- Format project budgets for display.

SELECT
    ProjectID,
    ProjectName,
    Budget,
    FORMAT(Budget, 'N2') AS FormattedBudget
FROM dbo.Projects
ORDER BY Budget DESC;
GO

-- ------------------------------------------------------------
-- 4.6 Date truncation patterns
-- ------------------------------------------------------------

SELECT
    EmployeeID,
    HireDate,
    DATEADD
    (
        MONTH,
        DATEDIFF(MONTH, 0, HireDate),
        0
    ) AS MonthStart
FROM dbo.Employees
ORDER BY HireDate;
GO

-- Truncate to the beginning of the year.

SELECT
    HireDate,
    DATEADD
    (
        YEAR,
        DATEDIFF(YEAR, 0, HireDate),
        0
    ) AS YearStart
FROM dbo.Employees
ORDER BY HireDate;
GO

-- Truncate to the beginning of the day for datetime values.

SELECT
    CAST(GETDATE() AS DATETIME) AS CurrentDateTime,
    CAST(CAST(GETDATE() AS DATE) AS DATETIME) AS DayStart;
GO

-- Group employees by month using a truncation pattern.

SELECT
    DATEADD
    (
        MONTH,
        DATEDIFF(MONTH, 0, HireDate),
        0
    ) AS HireMonth,
    COUNT(*) AS EmployeeCount
FROM dbo.Employees
GROUP BY
    DATEADD
    (
        MONTH,
        DATEDIFF(MONTH, 0, HireDate),
        0
    )
ORDER BY HireMonth;
GO
