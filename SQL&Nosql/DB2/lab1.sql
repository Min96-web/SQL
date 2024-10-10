USE lab1;

# setup
DROP DATABASE lab1;
CREATE DATABASE lab1;
USE lab1;

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
  ("The Imitation Game", 2014, 8),        #7
  ("Don't Look Up", 2014, 8);             #8 

INSERT INTO Genres (name) VALUES
  ("Action"), #1
  ("Comedy"), #2
  ("Drama"),  #3
  ("Sci-fi"); #4 

INSERT INTO MoviesGenres VALUES 
(1, 1), (1,4), (2, 2), (2, 3), (3, 1), (3, 3), (3, 4), (4, 3), (5, 3), (6, 1),(6, 3), (7, 3),(8, 3), (8, 2);

# 1
DROP VIEW IF EXISTS MovieGenre;
CREATE VIEW MovieGenre AS
	SELECT Movies.title, Genres.name AS genre
    FROM MoviesGenres
	JOIN Movies ON MoviesGenres.m_id = Movies.id
	JOIN Genres ON MoviesGenres.g_id = Genres.id;

SELECT title FROM MovieGenre WHERE genre = "sci-fi";

# 2
DROP VIEW IF EXISTS MoviesYears;
CREATE VIEW MoviesYears AS 
	SELECT concat(title, " (", year,  ")") AS movie_year
	FROM Movies
	ORDER BY movie_year;

SELECT * FROM MoviesYears;

# 3
DROP VIEW IF EXISTS TopRated;
CREATE VIEW TopRated AS
	SELECT title AS top_movie
    FROM Movies
    WHERE rating > 8;

SELECT * FROM TopRated;

# 4
DROP VIEW IF EXISTS GenreCount;
CREATE VIEW GenreCount AS 
	SELECT 
		Genres.name AS genre,
        count(*) AS count
    FROM MoviesGenres
	JOIN Genres ON MoviesGenres.g_id = Genres.id
    GROUP BY Genres.id;

SELECT * FROM GenreCount;

# 5
DROP VIEW IF EXISTS GenreRatings;
CREATE VIEW GenreRatings AS 
	SELECT 
		Genres.name AS genre,
        avg(Movies.rating) AS avg_rating 
    FROM MoviesGenres
	JOIN Genres ON MoviesGenres.g_id = Genres.id
    JOIN Movies ON MoviesGenres.m_id = Movies.id
    GROUP BY Genres.id;

SELECT *
FROM GenreRatings
ORDER BY avg_rating DESC
LIMIT 1;
