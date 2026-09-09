CREATE DATABASE EmployeeEnterpriseDB;
GO

USE EmployeeEnterpriseDB;
GO

CREATE TABLE dbo.Departments
(
    DepartmentID INT IDENTITY(1,1) NOT NULL,
    DepartmentName VARCHAR(100) NOT NULL,
    Location VARCHAR(100) NULL,

    CONSTRAINT PK_Departments
        PRIMARY KEY (DepartmentID),

    CONSTRAINT UQ_Departments_DepartmentName
        UNIQUE (DepartmentName)
);

CREATE TABLE dbo.Employees
(
    EmployeeID INT IDENTITY(1001,1) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(150) NOT NULL,
    Phone VARCHAR(20) NULL,
    HireDate DATE NOT NULL,
    JobTitle VARCHAR(100) NOT NULL,
    DepartmentID INT NULL,
    ManagerID INT NULL,
    EmploymentStatus VARCHAR(30) NOT NULL,
    CONSTRAINT PK_Employees
        PRIMARY KEY (EmployeeID),
    CONSTRAINT UQ_Employees_Email
        UNIQUE (Email),
    CONSTRAINT FK_Employees_Department
        FOREIGN KEY (DepartmentID)
        REFERENCES dbo.Departments(DepartmentID),
    CONSTRAINT FK_Employees_Manager
        FOREIGN KEY (ManagerID)
        REFERENCES dbo.Employees(EmployeeID)
);

CREATE TABLE dbo.Projects
(
    ProjectID INT IDENTITY(2001,1) NOT NULL,
    ProjectName VARCHAR(150) NOT NULL,
    DepartmentID INT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    Budget DECIMAL(15,2) NOT NULL,
    ProjectStatus VARCHAR(30) NOT NULL,

    CONSTRAINT PK_Projects
        PRIMARY KEY (ProjectID),

    CONSTRAINT UQ_Projects_ProjectName
        UNIQUE (ProjectName),

    CONSTRAINT FK_Projects_Department
        FOREIGN KEY (DepartmentID)
        REFERENCES dbo.Departments(DepartmentID)
);

CREATE TABLE dbo.EmployeeProjects
(
    EmployeeID INT NOT NULL,
    ProjectID INT NOT NULL,
    ProjectRole VARCHAR(100) NULL,
    AssignmentDate DATE NOT NULL,
    AssignmentStatus VARCHAR(30) NOT NULL,

    CONSTRAINT PK_EmployeeProjects
        PRIMARY KEY (EmployeeID, ProjectID),

    CONSTRAINT FK_EmployeeProjects_Employee
        FOREIGN KEY (EmployeeID)
        REFERENCES dbo.Employees(EmployeeID),

    CONSTRAINT FK_EmployeeProjects_Project
        FOREIGN KEY (ProjectID)
        REFERENCES dbo.Projects(ProjectID)
);

CREATE TABLE dbo.PerformanceReviews
(
    ReviewID INT IDENTITY(5001,1) NOT NULL,
    EmployeeID INT NOT NULL,
    ReviewDate DATE NOT NULL,
    Rating DECIMAL(3,2) NULL,
    ReviewerComments VARCHAR(500) NULL,

    CONSTRAINT PK_PerformanceReviews
        PRIMARY KEY (ReviewID),

    CONSTRAINT FK_PerformanceReviews_Employee
        FOREIGN KEY (EmployeeID)
        REFERENCES dbo.Employees(EmployeeID)
);

INSERT INTO dbo.Departments
(
    DepartmentName,
    Location
)
VALUES
    ('Engineering', 'Bangalore'),
    ('Human Resources', 'Mumbai'),
    ('Finance', 'Delhi'),
    ('Data & Analytics', 'Hyderabad'),
    ('Information Technology', 'Pune'),
    ('Operations', 'Chennai'),
    ('Research & Development', 'Bangalore'),
    ('Legal & Compliance', 'Gurugram'),
    ('Corporate Strategy', 'Noida');

SELECT
    DepartmentID,
    DepartmentName,
    Location
FROM dbo.Departments
ORDER BY DepartmentID;


INSERT INTO dbo.Employees
(
    FirstName,
    LastName,
    Email,
    Phone,
    HireDate,
    JobTitle,
    DepartmentID,
    ManagerID,
    EmploymentStatus
)
VALUES
    ('Arjun', 'Mehta', 'arjun.mehta@enterprise.com',
     '9876501001', '2015-04-15', 'Chief Executive Officer',
     9, NULL, 'Active'),

    ('Priya', 'Sharma', 'priya.sharma@enterprise.com',
     '9876501002', '2017-06-20', 'Engineering Director',
     1, 1001, 'Active'),

    ('Rahul', 'Verma', 'rahul.verma@enterprise.com',
     '9876501003', '2018-01-10', 'HR Director',
     2, 1001, 'Active'),

    ('Sneha', 'Patel', 'sneha.patel@enterprise.com',
     '9876501004', '2019-03-12', 'Finance Manager',
     3, 1001, 'Active'),

    ('Vikram', 'Singh', 'vikram.singh@enterprise.com',
     '9876501005', '2019-08-01', 'Data Engineering Manager',
     4, 1001, 'Active'),

    ('Neha', 'Joshi', 'neha.joshi@enterprise.com',
     '9876501006', '2020-02-17', 'IT Manager',
     5, 1001, 'Active'),

    ('Karan', 'Gupta', 'karan.gupta@enterprise.com',
     '9876501007', '2020-07-06', 'Operations Manager',
     6, 1001, 'Active');


INSERT INTO dbo.Employees
(
    FirstName,
    LastName,
    Email,
    Phone,
    HireDate,
    JobTitle,
    DepartmentID,
    ManagerID,
    EmploymentStatus
)
VALUES
    ('Amit', 'Rao', 'amit.rao@enterprise.com',
     '9876501010', '2021-01-11', 'Senior Software Engineer',
     1, 1002, 'Active'),

    ('Ananya', 'Iyer', 'ananya.iyer@enterprise.com',
     '9876501011', '2022-05-23', 'Software Engineer',
     1, 1002, 'Active'),

    ('Rohit', 'Nair', 'rohit.nair@enterprise.com',
     '9876501012', '2023-02-13', 'Software Engineer',
     1, 1002, 'Active'),

    ('Meera', 'Kulkarni', 'meera.kulkarni@enterprise.com',
     '9876501013', '2021-09-15', 'HR Executive',
     2, 1003, 'Active'),

    ('Sanjay', 'Deshmukh', 'sanjay.deshmukh@enterprise.com',
     '9876501014', '2022-11-07', 'Financial Analyst',
     3, 1004, 'Active'),

    ('Divya', 'Menon', 'divya.menon@enterprise.com',
     '9876501015', '2021-12-01', 'Data Engineer',
     4, 1005, 'Active'),

    ('Nikhil', 'Bose', 'nikhil.bose@enterprise.com',
     '9876501016', '2023-04-18', 'Data Analyst',
     4, 1005, 'Active'),

    ('Ishita', 'Kapoor', 'ishita.kapoor@enterprise.com',
     '9876501017', '2022-03-21', 'DevOps Engineer',
     5, 1006, 'Active'),

    ('Varun', 'Malhotra', 'varun.malhotra@enterprise.com',
     '9876501018', '2024-01-08', 'Operations Analyst',
     6, 1007, 'Active'),

    ('Pooja', 'Shah', 'pooja.shah@enterprise.com',
     '9876501019', '2024-06-10', 'Business Analyst',
     9, 1001, 'Active'),

    /* Employee intentionally created without a department */
    ('Ritesh', 'Yadav', 'ritesh.yadav@enterprise.com',
     '9876501020', '2025-01-13', 'Management Trainee',
     NULL, 1001, 'Active'),

    /* Employee intentionally created without a manager */
    ('Kavya', 'Reddy', 'kavya.reddy@enterprise.com',
     '9876501021', '2024-10-01', 'Independent Consultant',
     7, NULL, 'Active'),

    /* Employee with inactive status */
    ('Manish', 'Tiwari', 'manish.tiwari@enterprise.com',
     '9876501022', '2020-10-19', 'Senior Operations Executive',
     6, 1007, 'On Leave');


SELECT
    EmployeeID,
    FirstName,
    LastName,
    JobTitle,
    DepartmentID,
    ManagerID,
    EmploymentStatus
FROM dbo.Employees
ORDER BY EmployeeID;

INSERT INTO dbo.Projects
(
    ProjectName,
    DepartmentID,
    StartDate,
    EndDate,
    Budget,
    ProjectStatus
)
VALUES
    ('Enterprise Data Platform', 4,
     '2024-01-15', NULL, 850000.00, 'Active'),

    ('Customer Analytics Portal', 4,
     '2024-04-01', NULL, 450000.00, 'Active'),

    ('HR Management System', 2,
     '2023-07-10', '2024-02-28', 300000.00, 'Completed'),

    ('Cloud Infrastructure Migration', 5,
     '2025-01-20', NULL, 700000.00, 'Active'),

    ('Financial Reporting Automation', 3,
     '2024-09-01', NULL, 275000.00, 'Active'),

    ('Operations Optimization', 6,
     '2025-03-15', NULL, 350000.00, 'Planned'),

    ('AI Research Initiative', 7,
     '2025-06-01', NULL, 1000000.00, 'Active'),

    /* Project intentionally without department */
    ('Corporate Innovation Program', NULL,
     '2025-07-01', NULL, 500000.00, 'Planned'),

    /* Project intentionally created without assignments */
    ('Legacy System Decommissioning', 5,
     '2026-01-01', NULL, 180000.00, 'Planned');


SELECT
    ProjectID,
    ProjectName,
    DepartmentID,
    StartDate,
    EndDate,
    Budget,
    ProjectStatus
FROM dbo.Projects
ORDER BY ProjectID;


INSERT INTO dbo.EmployeeProjects
(
    EmployeeID,
    ProjectID,
    ProjectRole,
    AssignmentDate,
    AssignmentStatus
)
VALUES
    (1002, 2001, 'Project Director', '2024-01-15', 'Active'),
    (1008, 2001, 'Senior Developer', '2024-01-20', 'Active'),
    (1009, 2001, 'Software Engineer', '2024-02-01', 'Active'),
    (1010, 2001, 'Software Engineer', '2024-03-01', 'Active'),

    (1005, 2002, 'Project Manager', '2024-04-01', 'Active'),
    (1015, 2002, 'Data Engineer', '2024-04-05', 'Active'),
    (1016, 2002, 'Data Analyst', '2024-04-10', 'Active'),

    (1003, 2003, 'Project Sponsor', '2023-07-10', 'Completed'),
    (1011, 2003, 'HR Executive', '2023-07-15', 'Completed'),

    (1006, 2004, 'Project Manager', '2025-01-20', 'Active'),
    (1017, 2004, 'DevOps Engineer', '2025-01-25', 'Active'),

    (1004, 2005, 'Project Manager', '2024-09-01', 'Active'),
    (1012, 2005, 'Financial Analyst', '2024-09-10', 'Active'),

    /* Pending assignment */
    (1018, 2006, 'Operations Analyst', '2025-03-20', 'Pending'),

    (1007, 2007, 'Project Sponsor', '2025-06-01', 'Active'),
    (1013, 2007, 'Research Consultant', '2025-06-10', 'Active'),

    /* Employee without department assigned to corporate project */
    (1020, 2008, 'Trainee', '2025-07-05', 'Pending');


SELECT
    EmployeeID,
    ProjectID,
    ProjectRole,
    AssignmentDate,
    AssignmentStatus
FROM dbo.EmployeeProjects
ORDER BY ProjectID, EmployeeID;


INSERT INTO dbo.PerformanceReviews
(
    EmployeeID,
    ReviewDate,
    Rating,
    ReviewerComments
)
VALUES
    (1002, '2024-12-15', 4.80, 'Excellent technical and leadership performance.'),
    (1002, '2025-12-15', 4.90, 'Outstanding engineering leadership.'),

    (1003, '2024-12-20', 4.50, 'Strong people management skills.'),
    (1003, '2025-12-20', 4.60, 'Consistently strong HR leadership.'),

    (1004, '2024-12-18', 4.20, 'Good financial planning and analysis.'),
    (1005, '2024-12-17', 4.70, 'Excellent data engineering capabilities.'),

    (1008, '2024-12-10', 4.40, 'Strong software development performance.'),
    (1008, '2025-12-10', 4.60, 'Improved system design and ownership.'),

    (1009, '2024-12-11', 3.90, 'Good progress with room for improvement.'),
    (1010, '2024-12-12', NULL, 'Review rating pending final calibration.'),

    (1015, '2025-01-05', 4.80, 'Strong data engineering contribution.'),
    (1016, '2025-01-06', 4.30, 'Good analytical performance.'),

    /* Review exists but comments are unavailable */
    (1017, '2025-02-01', 4.10, NULL),

    /* Rating intentionally unavailable */
    (1018, '2025-02-10', NULL, NULL);



SELECT
    ReviewID,
    EmployeeID,
    ReviewDate,
    Rating,
    ReviewerComments
FROM dbo.PerformanceReviews
ORDER BY EmployeeID, ReviewDate;


SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;



