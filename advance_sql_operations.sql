-- SQL Project - Library Management System 

SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM members;
SELECT * FROM return_status;

/*
Task 13: 
Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.
*/

-- issued_status == members == books == return_status
-- filter books which is return
-- overdue > 30 
SELECT 
    ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    DATEDIFF(DAY, ist.issued_date, GETDATE()) AS over_dues_days
FROM issued_status AS ist
JOIN members AS m
    ON m.member_id = ist.issued_member_id
JOIN books AS bk
    ON bk.isbn = ist.issued_book_isbn
LEFT JOIN return_status AS rs
    ON rs.issued_id = ist.issued_id
WHERE 
    rs.return_date IS NULL
    AND DATEDIFF(DAY, ist.issued_date, GETDATE()) > 30
ORDER BY ist.issued_member_id;

-- 
/*    
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
*/
CREATE PROCEDURE add_return_records
    @p_return_id VARCHAR(10),
    @p_issued_id VARCHAR(10),
    @p_book_quality VARCHAR(10)
AS
BEGIN
    DECLARE @v_isbn VARCHAR(50);
    DECLARE @v_book_name VARCHAR(80);

    -- Insert into return_status
    INSERT INTO return_status (return_id, issued_id, return_date, book_quality)
    VALUES (@p_return_id, @p_issued_id, GETDATE(), @p_book_quality);

    -- Get book details from issued_status
    SELECT 
        @v_isbn = issued_book_isbn,
        @v_book_name = issued_book_name
    FROM issued_status
    WHERE issued_id = @p_issued_id;

    -- Update book status
    UPDATE books
    SET status = 'Yes'
    WHERE isbn = @v_isbn;

    -- Print message
    PRINT 'Thank you for returning the book: ' + ISNULL(@v_book_name, '');
END;

/*Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.*/
SELECT 
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) AS number_book_issued,
    COUNT(rs.return_id) AS number_of_book_return,
    SUM(bk.rental_price) AS total_revenue
INTO branch_reports
FROM issued_status AS ist
JOIN employees AS e
    ON e.emp_id = ist.issued_emp_id
JOIN branch AS b
    ON e.branch_id = b.branch_id
LEFT JOIN return_status AS rs
    ON rs.issued_id = ist.issued_id
JOIN books AS bk
    ON ist.issued_book_isbn = bk.isbn
GROUP BY b.branch_id, b.manager_id;

/*Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.*/
SELECT *
INTO active_members
FROM members
WHERE member_id IN (
    SELECT DISTINCT issued_member_id
    FROM issued_status
    WHERE issued_date >= DATEADD(MONTH, -2, GETDATE())
);

/*Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.*/



    SELECT TOP 3
    e.emp_name,
    b.branch_id,
    b.branch_address,
    COUNT(ist.issued_id) AS no_book_issued
FROM issued_status AS ist
JOIN employees AS e
    ON e.emp_id = ist.issued_emp_id
JOIN branch AS b
    ON e.branch_id = b.branch_id
GROUP BY 
    e.emp_name,
    b.branch_id,
    b.branch_address
ORDER BY 
    no_book_issued DESC;

    /*Task 18: Identify Members Issuing High-Risk Books
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.*/
SELECT 
    m.member_name,
    b.book_title,
    COUNT(*) AS damaged_issue_count
FROM issued_status AS ist
JOIN members AS m
    ON m.member_id = ist.issued_member_id
JOIN books AS b
    ON b.isbn = ist.issued_book_isbn
WHERE b.status = 'damaged'
GROUP BY 
    m.member_name,
    b.book_title
HAVING COUNT(*) > 2;

/*Task 19: Stored Procedure Objective: Create a stored procedure to manage the status of books in a library system. Description: Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows: The stored procedure should take the book_id as an input parameter. The procedure should first check if the book is available (status = 'yes'). If the book is available, it should be issued, and the status in the books table should be updated to 'no'. If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.*/
CREATE PROCEDURE issue_book
    @p_issued_id VARCHAR(10),
    @p_issued_member_id VARCHAR(30),
    @p_issued_book_isbn VARCHAR(30),
    @p_issued_emp_id VARCHAR(10)
AS
BEGIN
    DECLARE @v_status VARCHAR(10);

    -- Get book status
    SELECT @v_status = status
    FROM books
    WHERE isbn = @p_issued_book_isbn;

    -- Check if book exists
    IF @v_status IS NULL
    BEGIN
        THROW 50001, 'Book does not exist', 1;
        RETURN;
    END

    -- If book is available
    IF @v_status = 'yes'
    BEGIN
        INSERT INTO issued_status(
            issued_id, 
            issued_member_id, 
            issued_date, 
            issued_book_isbn, 
            issued_emp_id
        )
        VALUES (
            @p_issued_id, 
            @p_issued_member_id, 
            GETDATE(), 
            @p_issued_book_isbn, 
            @p_issued_emp_id
        );

        UPDATE books
        SET status = 'no'
        WHERE isbn = @p_issued_book_isbn;

        PRINT 'Book issued successfully';
    END
    ELSE
    BEGIN
        THROW 50002, 'Book is not available', 1;
    END
END;
SELECT * FROM books;

DROP PROCEDURE IF EXISTS issue_book;

CREATE PROCEDURE issue_book
    @p_issued_id VARCHAR(10),
    @p_issued_member_id VARCHAR(30),
    @p_issued_book_isbn VARCHAR(30),
    @p_issued_emp_id VARCHAR(10)
AS
BEGIN
    DECLARE @v_status VARCHAR(10);

    SELECT @v_status = status
    FROM books
    WHERE isbn = @p_issued_book_isbn;

    IF @v_status = 'yes'
    BEGIN
        INSERT INTO issued_status(
            issued_id,
            issued_member_id,
            issued_date,
            issued_book_isbn,
            issued_emp_id
        )
        VALUES (
            @p_issued_id,
            @p_issued_member_id,
            GETDATE(),
            @p_issued_book_isbn,
            @p_issued_emp_id
        );

        UPDATE books
        SET status = 'no'
        WHERE isbn = @p_issued_book_isbn;

        PRINT 'Book issued successfully';
    END
    ELSE
    BEGIN
        THROW 50002, 'Book is not available', 1;
    END
END;
SELECT * FROM books;
/*Task 20: Create Table As Select (CTAS) Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include: The number of overdue books. The total fines, with each day's fine calculated at $0.50. The number of books issued by each member. The resulting table should show: Member ID Number of overdue books Total fines */
SELECT 
    ist.issued_member_id AS member_id,
COUNT(*) as overdue_books,
SUM(
DATEDIFF(DAY, ist.issued_date, GETDATE()) * 0.50
) total_fines ,
COUNT(*) as total_books_issued

INTO member_overdue_summary
FROM issued_status ist
LEFT JOIN return_status rs
    ON ist.issued_id=rs.issued_id
    WHERE rs.return_date IS NULL
    AND DATEDIFF(DAY, ist.issued_date, GETDATE() )>30
    GROUP BY ist.issued_member_id;
    SELECT * 
FROM member_overdue_summary;

--END OF PROJECT--