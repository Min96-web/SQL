-- LABORATION 1 - INSTRUKTIONER --
-- 1. Skapa en vy (MovieGenre) som listar alla filmer och deras genre
--    Vi ska t ex kunna fråga vyn om SELECT title FROM MovieGenre WHERE genre = "sci-fi"
--    OBS queryn frågar vyn om 'genre' (och det ska den (det ska inte stå 'name')).
-- 
-- 2. Skapa en vy (MoviesYears) som omformatterar resultat så att vi får filmtitel och årtal 
--    sorterade på titel i ett fält likt:
--
--    Star Wars - The Last Jedi (2017)
--    The Emoji Movie (2016)
--    osv vid SELECT * FROM MoviesYears
--    
-- 3. En vy (TopRated) som bara innehåller de filmer som har betyg 9 eller 10 
--    (av en skala 1-10). 
--    Ex på användning: SELECT * FROM TopRated;
--
-- 4. En vy (GenreCount) som visar namn på genre och antal filmer som det finns från varje genre.
--    Ex på användning SELECT * FROM GenreCount;
--
-- 5. En vy (GenreRatings) som visar namn på genre och medelbetyg (avg_rating) för alla filmer inom varje genre.
--    Skriv sedan en query som använder vyn för att visa namn på den genre som har högst medelbetyg.
--
Drop database lab1;
Create database lab1;
Use lab1;

  CREATE TABLE Movies (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,    
  title TEXT NOT NULL,    
  year INTEGER NOT NULL,    
  rating INTEGER DEFAULT 1
);   

CREATE TABLE Genres (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,    
  name TEXT NOT NULL
);    

CREATE TABLE MoviesGenres (
  m_id INTEGER NOT NULL,   
  g_id INTEGER NOT NULL
);

ALTER TABLE MoviesGenres 
  ADD CONSTRAINT FK_Movies FOREIGN KEY (m_id) REFERENCES Movies(id);

ALTER TABLE MoviesGenres 
  ADD CONSTRAINT FK_Genres FOREIGN KEY (g_id) REFERENCES Genres(id);

INSERT INTO Movies (title, year, rating) VALUES    
  ("Star Wars - The Last Jedi", 2017, 9), #1
  ("The Emoji Movie", 2016, 1),           #2
  ("The Matrix", 1999, 9),                #3
  ("The Shawshank Redemption", 1994, 10), #4   
  ("Titanic", 1997, 8),                   #5
  ("Wargames", 1983, 7),                  #6
  ("The Imitation Game", 2014, 8),       #7
  ("Don't Look Up", 2014, 8);             #8 

INSERT INTO Genres (name) VALUES
  ("Action"), #1
  ("Comedy"), #2
  ("Drama"),  #3
  ("Sci-fi"); #4 

INSERT INTO MoviesGenres VALUES 
(1, 1), (1,4), (2, 2), (2, 3), (3, 1), (3, 3), (3, 4), (4, 3), (5, 3), (6, 1),(6, 3), (7, 3),(8, 3), (8, 2);

select * from Movies;
-- select * from Genres;

-- CREATE VIEW MovieGenre AS 
    SELECT Movies.title, Genres.name AS genre FROM MoviesGenres
    JOIN Movies ON m_id = Movies.id
    JOIN Genres ON g_id = Genres.id;

-- SELECT * FROM MovieGenre;

create view MoviesYears as 
-- select distinct title from Movies;
-- select * from movies;
select concat (title, " (", year,  ")") as movie_year from Movies order by movie_year;
select * from MoviesYears;

create view TopRated as 
select title as top_movie from Movies where rating > 8 ;
select * from TopRated;

create view GenreCount as
select Genres.name, count(*) as count from MoviesGenres 
JOIN Genres ON g_id = Genres.id group by Genres.id;
select * from GenreCount;

DROP VIEW IF EXISTS GenreRatings;
CREATE VIEW GenreRatings AS 
    SELECT 
        Genres.name AS genre,
        avg(rating) AS avg_rating 
    FROM MoviesGenres
    JOIN Genres ON g_id = Genres.id
    JOIN Movies ON m_id = Movies.id
    GROUP BY Genres.id;

SELECT * FROM GenreRatings order by avg_rating desc
limit 1;




