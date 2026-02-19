--Question 6.1 
SELECT Title, Movie_id, Domestic_sales, International_sales
FROM boxoffice
INNER JOIN movies 
    ON boxoffice.movie_id = movies.id;

--Question 6.2
SELECT Title, Movie_id, Domestic_sales, International_sales
FROM boxoffice
INNER JOIN movies 
    ON boxoffice.movie_id = movies.id
WHERE International_sales > Domestic_sales;

--Question 6.3
SELECT Title, Movie_id, Rating
FROM boxoffice
INNER JOIN movies 
    ON boxoffice.movie_id = movies.id
ORDER BY Rating DESC;

--Question 7.1
SELECT distinct Building FROM employees;

--Question 7.2
SELECT * FROM Buildings;

--Question 7.3

SELECT Distinct Building_name, Role, Building
FROM Buildings
LEFT JOIN Employees
    ON buildings.building_name = employees.building;

--INTERVIEW QUESTIONS
SELECT pages.page_id, user_id, page_likes.page_id
FROM pages
LEFT JOIN page_likes ON pages.page_id = page_likes.page_id
WHERE user_id IS NULL
ORDER BY pages.page_id ASC;