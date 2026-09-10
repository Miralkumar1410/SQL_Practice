# SQL Practice

A structured SQL Server practice repository covering SQL fundamentals,
database design, DML operations, NULL handling, logical query
processing, joins, and aggregation.

The project is organized topic-wise so that each SQL concept can be
practiced independently using SQL Server Management Studio (SSMS).

## Project Structure

``` text
SQL_Practice/
│
├── README.md
│
└── src/
    ├── 01_basics_and_tables.sql
    ├── 02_data_types_and_constraints.sql
    ├── 03_basic_dml.sql
    ├── 04_null_semantics.sql
    ├── 05_logical_query_processing.sql
    ├── 06_joins.sql
    └── 07_aggregation_and_having.sql
```

## Database Used

The SQL scripts are designed around an **Employee & Enterprise
Management System** database.

The database includes tables such as:

-   `Departments`
-   `Employees`
-   `Projects`
-   `EmployeeProjects`
-   `PerformanceReviews`

The schema intentionally contains realistic cases such as:

-   Employees without a department
-   Employees without a manager
-   Projects without employee assignments
-   Nullable performance ratings
-   One-to-many and many-to-many relationships
-   Self-referencing employee-manager relationships

These cases make the exercises useful for understanding real SQL
behavior rather than only simple textbook examples.

------------------------------------------------------------------------

# SQL Topics Covered

## 01 --- SQL Basics & Table Creation

**File:** `src/01_basics_and_tables.sql`

Covers the foundation of SQL Server and relational database design.

### Topics

-   SQL fundamentals
-   Relational database concepts
-   SQL Server architecture
-   Database creation
-   Schema and table creation
-   `CREATE DATABASE`
-   `CREATE TABLE`
-   Primary keys
-   Foreign-key relationships
-   Identity columns
-   Table relationships
-   Sample data insertion
-   SSMS database exploration

This script establishes the database used by the remaining practice
files.

------------------------------------------------------------------------

## 02 --- Data Types & Constraints

**File:** `src/02_data_types_and_constraints.sql`

Covers SQL Server data types and data-integrity constraints.

### Topics

-   `INT`
-   `VARCHAR`
-   `DATE`
-   `DECIMAL`
-   `BIT`
-   `IDENTITY`
-   `NOT NULL`
-   `PRIMARY KEY`
-   `FOREIGN KEY`
-   `UNIQUE`
-   `CHECK`
-   `DEFAULT`
-   Referential integrity
-   Constraint validation
-   Valid vs invalid data
-   Constraint naming

The exercises demonstrate how constraints protect the database from
invalid or inconsistent data.

------------------------------------------------------------------------

## 03 --- Basic DML

**File:** `src/03_basic_dml.sql`

Covers Data Manipulation Language (DML).

### Topics

-   `INSERT`
-   `SELECT`
-   `UPDATE`
-   `DELETE`
-   `WHERE`
-   `ORDER BY`
-   `TOP`
-   Identity columns
-   Transaction-safe updates/deletes
-   `DELETE` vs `TRUNCATE` vs `DROP`
-   Foreign-key restrictions
-   Verifying changes after DML operations

The focus is on safely reading and modifying existing database data.

------------------------------------------------------------------------

## 04 --- NULL Semantics

**File:** `src/04_null_semantics.sql`

Covers how SQL Server handles missing or unknown values.

### Topics

-   Meaning of `NULL`
-   `IS NULL`
-   `IS NOT NULL`
-   Three-valued logic
-   `TRUE`, `FALSE`, and `UNKNOWN`
-   `ANSI_NULLS`
-   `COALESCE`
-   `ISNULL`
-   `NULLIF`
-   NULL behavior in comparisons
-   NULL behavior in aggregate functions
-   NULL values in joins
-   Common NULL-related mistakes

This topic is especially important because `NULL` does not behave like
an ordinary value.

------------------------------------------------------------------------

## 05 --- Logical Query Processing

**File:** `src/05_logical_query_processing.sql`

Covers the conceptual order in which SQL queries are logically
processed.

### Logical Processing Order

``` text
FROM
  ↓
ON
  ↓
JOIN
  ↓
WHERE
  ↓
GROUP BY
  ↓
HAVING
  ↓
SELECT
  ↓
DISTINCT
  ↓
ORDER BY
  ↓
TOP
```

### Topics

-   Logical vs physical query processing
-   `FROM`
-   `ON`
-   `JOIN`
-   `WHERE`
-   `GROUP BY`
-   `HAVING`
-   `SELECT`
-   `DISTINCT`
-   `ORDER BY`
-   `TOP`
-   Column alias limitations
-   Query execution plans
-   Predicate filtering
-   Why query clause order matters

Understanding this processing order makes complex SQL queries much
easier to reason about and debug.

------------------------------------------------------------------------

## 06 --- Joins

**File:** `src/06_joins.sql`

Covers SQL joins in depth using the employee, department, project, and
assignment relationships.

### Topics

-   `INNER JOIN`
-   `LEFT JOIN`
-   `RIGHT JOIN`
-   `FULL OUTER JOIN`
-   `CROSS JOIN`
-   `SELF JOIN`
-   Anti-join patterns
-   `ON` vs `WHERE`
-   One-to-many relationships
-   Many-to-many relationships
-   Junction tables
-   Employee-manager relationships
-   Row multiplication
-   Join matching behavior
-   Physical join concepts

Special attention is given to `SELF JOIN` because the `Employees` table
references itself through `ManagerID`.

------------------------------------------------------------------------

## 07 --- Aggregation & HAVING

**File:** `src/07_aggregation_and_having.sql`

Covers aggregation and grouped analysis.

### Topics

-   `COUNT`
-   `SUM`
-   `AVG`
-   `MIN`
-   `MAX`
-   `GROUP BY`
-   `HAVING`
-   `WHERE` vs `HAVING`
-   Conditional aggregation
-   `COUNT(*)`
-   `COUNT(column)`
-   NULL behavior in aggregates
-   Grouping by department
-   Project-level summaries
-   Performance-review summaries
-   Result-set grain
-   Aggregation after joins

The exercises focus on turning detailed rows into meaningful business
summaries.

------------------------------------------------------------------------

# Learning Sequence

The files are intentionally numbered and should be studied in order:

``` text
01 → Database & Tables
 ↓
02 → Data Types & Constraints
 ↓
03 → DML
 ↓
04 → NULL Semantics
 ↓
05 → Logical Query Processing
 ↓
06 → Joins
 ↓
07 → Aggregation & HAVING
```

Each topic builds on concepts introduced earlier.

For example:

-   Constraints from Topic 2 support the relationships used in Topic 6.
-   NULL behavior from Topic 4 becomes important when working with
    `LEFT JOIN` and `FULL OUTER JOIN`.
-   Logical query processing from Topic 5 explains why `WHERE` and
    `HAVING` behave differently in Topic 7.
-   Joins from Topic 6 are required for many of the aggregation
    exercises in Topic 7.

------------------------------------------------------------------------

# How to Run the Scripts

## 1. Open SQL Server Management Studio

Open **SSMS** and connect to your SQL Server instance.

## 2. Start with Topic 1

Open:

``` text
src/01_basics_and_tables.sql
```

Run the database and table creation sections first.

## 3. Select the Correct Database

After the database is created, use:

``` sql
USE EmployeeEnterpriseDB;
GO
```

The remaining scripts should be executed against this database.

## 4. Execute Topics Sequentially

Run:

``` text
02_data_types_and_constraints.sql
03_basic_dml.sql
04_null_semantics.sql
05_logical_query_processing.sql
06_joins.sql
07_aggregation_and_having.sql
```

in order.

## 5. Review Result Sets

Each practice query is designed to produce a meaningful result that can
be inspected in the SSMS **Results** grid.

------------------------------------------------------------------------

# Repository Conventions

### File Naming

Each SQL file follows:

``` text
<number>_<topic>.sql
```

Example:

``` text
06_joins.sql
```

### SQL Style

The scripts use:

-   Uppercase SQL keywords
-   Explicit schema names such as `dbo.Employees`
-   Meaningful aliases
-   Comments explaining important queries
-   Separate query sections
-   SSMS-compatible T-SQL
-   Screenshot labels for important practice queries

### Screenshot Convention

Practice queries contain comments such as:

``` sql
-- SCREENSHOT 1: Display employees with their departments
```

These comments identify queries whose result grids can be captured for
documentation, assignments, or portfolio purposes.

------------------------------------------------------------------------

# Key Learning Outcomes

After completing these seven topics, you should be able to:

-   Create relational databases and tables in SQL Server
-   Design primary-key and foreign-key relationships
-   Apply data types and integrity constraints
-   Insert, update, retrieve, and delete records
-   Understand SQL Server `NULL` behavior
-   Apply three-valued logic
-   Understand the logical processing order of SQL queries
-   Write and debug different types of joins
-   Handle self-referencing relationships
-   Work with many-to-many relationships
-   Perform grouped business analysis
-   Use aggregate functions effectively
-   Filter grouped results with `HAVING`
-   Recognize common SQL edge cases and mistakes
-   Read SQL queries from a logical execution perspective

------------------------------------------------------------------------

# Tools

-   **Database:** Microsoft SQL Server
-   **IDE:** SQL Server Management Studio (SSMS)
-   **Language:** T-SQL
-   **Repository Structure:** Topic-wise SQL scripts

------------------------------------------------------------------------

# Future Topics

The practice series can be extended with:

``` text
08 — Subqueries & CTEs
09 — Views
10 — Stored Procedures
```

These topics build directly on the concepts covered in the first seven
modules.

------------------------------------------------------------------------

# Author

**Miral Kumar Ratre**

SQL Practice Repository --- Employee & Enterprise Management System
