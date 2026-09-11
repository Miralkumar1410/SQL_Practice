USE EmployeeEnterpriseDB;
GO


-- ============================================================
-- PART 3: PIVOTING AND UNPIVOTING
-- ============================================================

-- ------------------------------------------------------------
-- 3.1 Static PIVOT
-- ------------------------------------------------------------

-- Count employees by employment status.

SELECT
    EmploymentStatus,
    COUNT(*) AS EmployeeCount
FROM dbo.Employees
GROUP BY EmploymentStatus
ORDER BY EmploymentStatus;
GO

-- Convert employment statuses into separate columns.

SELECT
    Active,
    [On Leave],
    Resigned,
    Terminated
FROM
(
    SELECT
        EmploymentStatus,
        EmployeeID
    FROM dbo.Employees
) AS SourceData
PIVOT
(
    COUNT(EmployeeID)
    FOR EmploymentStatus IN
    (
        Active,
        [On Leave],
        Resigned,
        Terminated
    )
) AS PivotData;
GO

-- ------------------------------------------------------------
-- 3.2 Static PIVOT by department
-- ------------------------------------------------------------

-- Show active employee counts as department columns.

SELECT
    Active
FROM
(
    SELECT
        d.DepartmentName,
        e.EmployeeID
    FROM dbo.Departments AS d
    LEFT JOIN dbo.Employees AS e
        ON d.DepartmentID = e.DepartmentID
       AND e.EmploymentStatus = 'Active'
) AS SourceData
PIVOT
(
    COUNT(EmployeeID)
    FOR DepartmentName IN
    (
        [Engineering],
        [Human Resources],
        [Finance],
        [Data & Analytics],
        [Information Technology],
        [Operations],
        [Research & Development],
        [Legal & Compliance],
        [Corporate Strategy]
    )
) AS PivotData;
GO

-- A more useful department-by-status pivot.

SELECT
    DepartmentName,
    [Active],
    [On Leave]
FROM
(
    SELECT
        d.DepartmentName,
        e.EmploymentStatus,
        e.EmployeeID
    FROM dbo.Departments AS d
    LEFT JOIN dbo.Employees AS e
        ON d.DepartmentID = e.DepartmentID
) AS SourceData
PIVOT
(
    COUNT(EmployeeID)
    FOR EmploymentStatus IN
    (
        [Active],
        [On Leave]
    )
) AS PivotData
ORDER BY DepartmentName;
GO

-- ------------------------------------------------------------
-- 3.3 PIVOT using project status
-- ------------------------------------------------------------

SELECT
    [Active],
    [Completed],
    [Planned],
    [On Hold],
    [Cancelled]
FROM
(
    SELECT
        ProjectStatus,
        ProjectID
    FROM dbo.Projects
) AS SourceData
PIVOT
(
    COUNT(ProjectID)
    FOR ProjectStatus IN
    (
        [Active],
        [Completed],
        [Planned],
        [On Hold],
        [Cancelled]
    )
) AS PivotData;
GO

-- ------------------------------------------------------------
-- 3.4 Dynamic PIVOT
-- ------------------------------------------------------------

DECLARE @Columns NVARCHAR(MAX);
DECLARE @SQL NVARCHAR(MAX);

SELECT
    @Columns = STRING_AGG(
        QUOTENAME(EmploymentStatus),
        ','
    )
FROM
(
    SELECT DISTINCT EmploymentStatus
    FROM dbo.Employees
) AS StatusValues;

SET @SQL = N'
SELECT ' + @Columns + N'
FROM
(
    SELECT
        EmploymentStatus,
        EmployeeID
    FROM dbo.Employees
) AS SourceData
PIVOT
(
    COUNT(EmployeeID)
    FOR EmploymentStatus IN (' + @Columns + N')
) AS PivotData;';

EXEC sys.sp_executesql @SQL;
GO

-- ------------------------------------------------------------
-- 3.5 UNPIVOT
-- ------------------------------------------------------------

WITH DepartmentStatus AS
(
    SELECT
        d.DepartmentName,
        SUM
        (
            CASE
                WHEN e.EmploymentStatus = 'Active' THEN 1
                ELSE 0
            END
        ) AS ActiveEmployees,
        SUM
        (
            CASE
                WHEN e.EmploymentStatus = 'On Leave' THEN 1
                ELSE 0
            END
        ) AS EmployeesOnLeave
    FROM dbo.Departments AS d
    LEFT JOIN dbo.Employees AS e
        ON d.DepartmentID = e.DepartmentID
    GROUP BY
        d.DepartmentID,
        d.DepartmentName
)
SELECT
    DepartmentName,
    EmploymentStatus,
    EmployeeCount
FROM DepartmentStatus
UNPIVOT
(
    EmployeeCount
    FOR EmploymentStatus IN
    (
        ActiveEmployees,
        EmployeesOnLeave
    )
) AS UnpivotData
ORDER BY DepartmentName, EmploymentStatus;
GO

