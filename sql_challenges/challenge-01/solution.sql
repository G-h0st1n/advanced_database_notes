--lesson 1

    --question 1
    SELECT Title FROM movies;

    --question 2
    SELECT Director FROM movies;

    --question 3
    SELECT title, director FROM movies;

    --question 4
    SELECT title, year FROM movies;

    --question 5
    SELECT * FROM movies;

--lesson 2

    --question 1
    SELECT * FROM movies WHERE id=6;

    --question 2
    SELECT * FROM movies WHERE Year BETWEEN 2000 and 2010;

    --question 3
    SELECT * FROM movies WHERE Year NOT BETWEEN 2000 and 2010;

    --question 4
    SELECT * FROM movies WHERE Id IN (1,2,3,4,5);

--lesson 3

    --question 1
    SELECT * FROM movies
    WHERE Title LIKE "%Toy%";

    --question 2
    SELECT * FROM movies
    WHERE Director = "John Lasseter";

    --question 3
    SELECT * FROM movies
    WHERE Director != "John Lasseter";

    --question 4
    SELECT * FROM movies
    WHERE Title LIKE "WALL-_";

--lesson 4

    --question 1
    SELECT DISTINCT Director FROM movies
    ORDER BY Director ASC;

    --question 2
    SELECT DISTINCT * FROM movies
    ORDER BY YEAR DESC
    LIMIT 4;

    --question 3
    SELECT DISTINCT * FROM movies
    ORDER BY Title ASC
    LIMIT 5;

    --question 4
    SELECT DISTINCT * FROM movies
    ORDER BY Title ASC
    LIMIT 5 OFFSET 5;

--lesson 5

    --question 1
    SELECT * FROM north_american_cities WHERE Country = "Canada";

    --question 2
    SELECT * FROM north_american_cities WHERE Country = "United States" ORDER BY Latitude DESC;

    --question 3
    SELECT * FROM north_american_cities WHERE Longitude < -87.629798 ORDER BY Longitude ASC ;

    --question 4
    SELECT * FROM north_american_cities WHERE Country = "Mexico" ORDER BY Population DESC LIMIT 2 ;

    --question 5
    SELECT * FROM north_american_cities WHERE Country = "United States" ORDER BY Population DESC LIMIT 2 OFFSET 2 ;