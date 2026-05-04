# library_mgt_system
Project Overview

Project Title: Library Management System

Database: library_db

This project is about building a Library Management System using SQL. It shows how to create and manage database tables, add, update, delete, and view data (CRUD operations), and write advanced SQL queries.
The main goal of this project is to demonstrate skills in designing databases, managing data, and writing efficient SQL queries.

Objectives
Create the Database: Set up the Library Management System database and create tables like branches, employees, members, books, issued status, and return status. Also, add sample data into these tables.
Perform CRUD Operations: Learn how to insert (create), view (read), update, and delete data in the database.
Use CTAS (Create Table As Select): Create new tables using the results of existing queries.
Write Advanced SQL Queries: Write complex SQL queries to find and analyze useful information from the database.

Database Structure Overview
<img width="1920" height="1080" alt="library_db ERD diagram" src="https://github.com/user-attachments/assets/0d85dc4a-fda6-4ada-9370-1ae56fb37858" />

The database consists of the following main entities:
Branch: Stores information about library branches.
Employees: Contains details of employees working in each branch.
Members: Stores registered library members.
Books: Maintains book details and availability status.
Issued_Status: Tracks which books are issued, to whom, and by which employee.
Return_Status: Records returned books and return dates.

Key Functionalities
Issue books to members
Update book availability status
Track returned books
Identify overdue books
Calculate fines for late returns
Generate reports using SQL queries

CRUD Operations – Overview
CRUD stands for Create, Read, Update, and Delete, which are the four basic operations used to manage data in a database.
CREATE (INSERT): Adds new records into a table (e.g., adding new books or members).
READ (SELECT): Retrieves and views data from one or more tables.
UPDATE: Modifies existing records to keep data accurate and up to date (e.g., updating member details).
DELETE: Removes unwanted or incorrect records from the database (e.g., deleting issued book entries).

Advanced SQL Operations Overview
This project demonstrates advanced SQL techniques applied to a Library Management System to manage data efficiently and generate meaningful insights from multiple related tables.

Key Advanced SQL Operations
Joins
Combined multiple tables such as books, members, employees, issued status, and return status to build complete datasets for analysis.
Aggregation
Used functions like COUNT and SUM to calculate total books issued, returns, and revenue for reporting purposes.
CTAS (Create Table As Select)
Created new tables from query results to store summaries such as active members and book issue reports for better performance and analysis.
Date Functions
Used DATEDIFF and DATEADD to track overdue books and analyze member activity over time.
Conditional Filtering
Applied WHERE and HAVING clauses to filter records and extract specific insights like overdue books and high activity members.
Stored Procedures
Automated processes for issuing and returning books with built-in business rules and error handling for data consistency.
Reporting Queries
Generated performance reports for branches, employees, and overall library operations to support decision making.

Conclusion:
This project demonstrates practical SQL skills used to design and manage a Library Management System. It includes database creation, data manipulation using CRUD operations, and advanced SQL querying for analysis and reporting. The project provides a strong foundation in database management and real-world data analysis.
