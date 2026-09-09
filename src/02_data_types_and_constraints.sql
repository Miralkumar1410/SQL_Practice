ALTER TABLE dbo.Employees
ADD CONSTRAINT CK_Employees_EmploymentStatus
CHECK
(
    EmploymentStatus IN
    ('Active', 'On Leave', 'Resigned', 'Terminated')
);


ALTER TABLE dbo.Employees
ADD CONSTRAINT DF_Employees_EmploymentStatus
DEFAULT 'Active'
FOR EmploymentStatus;


ALTER TABLE dbo.Projects
ADD CONSTRAINT CK_Projects_ProjectStatus
CHECK
(
    ProjectStatus IN
    ('Planned', 'Active', 'Completed', 'On Hold', 'Cancelled')
);

ALTER TABLE dbo.Projects
ADD CONSTRAINT CK_Projects_Budget
CHECK (Budget >= 0);


ALTER TABLE dbo.PerformanceReviews
ADD CONSTRAINT CK_PerformanceReviews_Rating
CHECK
(
    Rating IS NULL
    OR Rating BETWEEN 1.00 AND 5.00
);


ALTER TABLE dbo.EmployeeProjects
ADD CONSTRAINT CK_EmployeeProjects_AssignmentStatus
CHECK
(
    AssignmentStatus IN
    ('Pending', 'Active', 'Completed', 'Removed')
);


