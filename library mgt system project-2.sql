--LIBRARY MANAGEMENT SYSTEM USING SQL PROJECT-2
--1 DATABASE  AND TABLE CREATION
--create database library
DROP TABLE IF EXISTS branch;
--CREATE TABLE "BRANCH"
CREATE TABLE branch
(
              branch_id VARCHAR(10) PRIMARY KEY,
              manager_id VARCHAR(10),
              branch_address VARCHAR(30),
              contact_number VARCHAR(15)
);
INSERT INTO dbo.branch SELECT* FROM [dbo].[branch_1]   --import from dbo-branch1 to dbo.branch
SELECT * FROM branch;
DROP TABLE [dbo].[branch_1];

--CREATE TABLE EMPLOYEES
CREATE TABLE employees
(
emp_id VARCHAR(10) PRIMARY KEY,
emp_name VARCHAR(30),
position VARCHAR(30),
salary DECIMAL(10,2),
branch_id VARCHAR(10),
FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);

INSERT INTO dbo.employees SELECT * FROM [dbo].[employees_1];
SELECT * FROM employees;

DROP TABLE [dbo].[employees_1];

--CREATE TABLE MEMBERS
DROP TABLE IF EXISTS members;

CREATE TABLE members
(
member_id VARCHAR(10) PRIMARY KEY,
member_name VARCHAR(30),
member_address VARCHAR(30),
reg_date DATE
);


INSERT INTO dbo.members SELECT * FROM [dbo].[members1] ;
SELECT * FROM members;
DROP TABLE [dbo].[members1];

--CREATE TABLE BOOKS
DROP TABLE IF EXISTS books;

CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);

INSERT INTO dbo.books SELECT * FROM [dbo].[books1];
SELECT * FROM books;
DROP TABLE  [dbo].[books1];


-- Create table IssueStatus
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10),
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);
INSERT INTO issued_status SELECT * FROM [dbo].[issued_status1];
SELECT * FROM issued_status;
DROP TABLE  [dbo].[issued_status1];


-- Create table ReturnStatus
DROP TABLE IF EXISTS return_status;

CREATE TABLE return_status
(
    return_id VARCHAR(10) PRIMARY KEY,
    issued_id VARCHAR(10),
    return_book_name VARCHAR(80) NULL,
    return_date DATE NULL,
    return_book_isbn VARCHAR(50) NULL,

    -- Foreign Key 1 (ISBN → books table)
    FOREIGN KEY (return_book_isbn) 
    REFERENCES books(isbn),

    -- Foreign Key 2 (issued_id → issued_status table)
    FOREIGN KEY (issued_id) 
    REFERENCES issued_status(issued_id)
);


SELECT issued_id FROM [dbo].[return_status2]
except
SELECT issued_id FROM [dbo].[issued_status]


INSERT INTO return_status SELECT * FROM [dbo].[return_status2] where issued_id not in ('IS101',
'IS103',
'IS105');
DROP TABLE [dbo].[return_status1];

DROP TABLE [dbo].[return_status2];
ALTER TABLE return_status2
ALTER COLUMN return_book_name VARCHAR(100) NULL;

ALTER TABLE return_status2
ALTER COLUMN return_book_isbn VARCHAR(50) NULL;
SELECT * FROM return_status;
--Data correction
Update [dbo].[return_status2]
SET return_book_isbn = null
where return_book_isbn = 'NULL'
SELECT * FROM return_status2;


UPDATE return_status2
SET return_book_name=null
WHERE return_book_name='NULL'

--FOREIGN KEY 
ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES  members (member_id)


ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES  books(isbn)

ALTER TABLE books
ADD 
    book_title VARCHAR(80),
    category VARCHAR(30),
    rental_price DECIMAL(10,2),
    status VARCHAR(10),
    author VARCHAR(30),
    publisher VARCHAR(30);
;
SELECT * FROM books;

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);


/*ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_id(issued_id);*/






