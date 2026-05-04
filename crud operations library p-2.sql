--2 CRUD OPERATIONS
SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM members;

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books(isbn, book_title, category, rental_price, status, author,publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;


-- Task 2: Update an Existing Member's Address
UPDATE members
SET member_address='2026 Oak St'
WHERE member_id='C119';


-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

SELECT * FROM issued_status
WHERE issued_id = 'IS121';

DELETE FROM issued_status
WHERE  issued_id = 'IS121' ;
SELECT * FROM issued_status;


-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT * FROM issued_status
WHERE issued_emp_id='E101'

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT issued_emp_id,
COUNT(*) FROM issued_status
GROUP BY issued_emp_id; --Your query is correct only if the question asks about employees.

SELECT
    issued_emp_id,
    COUNT(*) --Your query will run and give output, but it is not correct for the task ❌ because it finds employees, not members.
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(*) > 1

SELECT
    issued_member_id,
    COUNT(*) AS total_books --this is correct because it ask about member
FROM issued_status
GROUP BY issued_member_id
HAVING COUNT(*) > 1;

--CTAS (Create Table As Select) is used to create a new table from the result of a SELECT query. 
--It helps quickly store filtered, transformed, or summarized data into a new table for reporting and performance optimization.

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
INTO book_issued_cnt
FROM issued_status AS ist
JOIN books AS b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title; 
--Task says:

/*Create summary table showing each book and total number of times issued

So this query:

✔ counts how many times each book was issued
✔ groups results book-wise
✔ stores results inside a new table called book_issued_cnt*/
SELECT * FROM
book_issued_cnt;

-- Task 7. Retrieve All Books in a Specific Category:
SELECT * FROM books
WHERE category='history';

-- Task 8: Find Total Rental Income by Category:
SELECT category,
SUM(rental_price) AS total_rental_income
FROM books 
GROUP BY category;

--TASK 9  List Members Who Registered in the Last 180 Days: --pending
-- TASK 9
INSERT INTO members(member_id, member_name, member_address, reg_date)
SELECT v.member_id, v.member_name, v.member_address, v.reg_date
FROM (VALUES
    ('C118', 'sam', '145 Main St', '2024-06-01'),
    ('C119', 'john', '133 Main St', '2024-05-01')
) AS v(member_id, member_name, member_address, reg_date)
WHERE NOT EXISTS (
    SELECT 1 
    FROM members m 
    WHERE m.member_id = v.member_id
);


SELECT * FROM members;



-- task 10 List Employees with Their Branch Manager's Name and their branch details:
SELECT 
    e1.*,
    b.manager_id,
    e2.emp_name as manager
FROM employees as e1
JOIN  
branch as b
ON b.branch_id = e1.branch_id
JOIN
employees as e2
ON b.manager_id = e2.emp_id
/*I used a self-join on the employees table along with a join to the branch table to retrieve each employee’s branch manager name. 
Since managers are also stored in the employees table, 
I joined the employees table twice using aliases to differentiate employee records from manager records.*/
-

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:
CREATE TABLE books_price_greater_than_seven
AS
SELECT  * FROM books
WHERE rental_price> 7 --is correct in MySQL / PostgreSQL, but ❌ not correct in SQL Server (which you are using). That’s why you are getting an error.

SELECT * INTO books_price_greater_than_seven
FROM books
WHERE rental_price>7;

SELECT * FROM books_price_greater_than_seven;

-- Task 12: Retrieve the List of Books Not Yet Returned
SELECT  
DISTINCT ist.issued_book_name
FROM issued_status as ist
LEFT JOIN
return_status as rs
ON ist.issued_id=rs.issued_id
WHERE rs.return_id is NULL
