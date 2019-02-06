
-- 1. Where the book is available and what row
SELECT * FROM groupprojectolap.dimbooks where available = 1 ;

-- 2. What books are not available and not shelved
SELECT * FROM groupprojectolap.dimbooks where available is null ;

-- 3. Book witht the greatest cost and not available to acquire top 3 books
SELECT * FROM groupprojectolap.dimbooks where available is null  ORDER BY bookCost DESC
LIMIT 3;

-- 4. Havent had any past due but live in california
SELECT * FROM groupprojectolap.dimborrowers where booksPastDue = 'N' and borrowerCity like 'CA';

-- 5. find all the empty isles in all locations //able to fill
select * from groupprojectolap.dimlocations where contents is null;

-- 6. Gets a count of how many books are in inventory
SELECT COUNT(inStock) AS 'Count of Available Books'
FROM groupprojectolap.facts;

-- 7. Gets a count of how many books on loan
SELECT COUNT(onLoan) AS 'Count of Books on Loan'
FROM groupprojectolap.facts;
