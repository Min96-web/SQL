#Minhui Zhong

DROP DATABASE lab6;
CREATE DATABASE lab6;
USE lab6;

 SET GLOBAL sql_mode=(SELECT CONCAT(@@sql_mode, ',ONLY_FULL_GROUP_BY'));
 SET GLOBAL sql_mode=(SELECT CONCAT(@@sql_mode, ',STRICT_TRANS_TABLES'));
 SET GLOBAL FOREIGN_KEY_CHECKS = 1;
 SET SQL_SAFE_UPDATES = 0;

# 1.Skapa databas
# Table för Authors
DROP TABLE IF EXISTS Authors;
CREATE TABLE Authors (
	id INT PRIMARY KEY AUTO_INCREMENT,
	username VARCHAR(50)UNIQUE,
	fullname VARCHAR(50)
);

# Table för Posts
DROP TABLE IF EXISTS Posts;
CREATE TABLE Posts(
	id INT PRIMARY KEY AUTO_INCREMENT,
    a_id INT,
	subject VARCHAR(50),
	content VARCHAR(200),
	posted DATETIME,
    last_edit DATETIME
    );
    
# Table för Comments
DROP TABLE IF EXISTS Comments;
CREATE TABLE Comments (
	id INT PRIMARY KEY AUTO_INCREMENT,
    p_id INT,
	name VARCHAR(50),
	subject VARCHAR(50),
	content VARCHAR(200),
	posted DATETIME
);

# Table för Categorys
DROP TABLE IF EXISTS Categorys;
CREATE TABLE Categorys (
	id INT PRIMARY KEY AUTO_INCREMENT,
	categoryname VARCHAR(50)
);

# Table för Post_categorys
DROP TABLE IF EXISTS Post_categorys;
CREATE TABLE Post_categorys (
	post_cate_id INT NOT NULL REFERENCES Posts(id),
	cate_id INT NOT NULL REFERENCES Categorys(id)
);

ALTER TABLE Post_categorys
ADD CONSTRAINT fk_post_cate_id FOREIGN KEY (post_cate_id) 
REFERENCES Posts(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Post_categorys
ADD CONSTRAINT fk_cate_id FOREIGN KEY (cate_id) 
REFERENCES Categorys(id)
ON DELETE CASCADE
ON UPDATE CASCADE;


# 2.1 Lägga till en skribent. Ska kunna köras som t ex CALL ADD_author("Ada", "Ada Lovelace");
SELECT * FROM Authors;
DROP PROCEDURE IF EXISTS ADD_author; 
DELIMITER //
CREATE PROCEDURE ADD_author(ADD_new_username VARCHAR(50), ADD_new_name VARCHAR(50)) # En procedure för att lägga till username och fullname
BEGIN
    INSERT INTO Authors(username,fullname) VALUES (ADD_new_username,ADD_new_name);
END //
DELIMITER ;


# 2.2 Lagga till en kategori
SELECT * FROM Categorys;
DROP PROCEDURE IF EXISTS ADD_category;
DELIMITER //
CREATE PROCEDURE ADD_category(ADD_new_categoryname VARCHAR(50)) # En procedure för att lägga till categoryname
BEGIN
    INSERT INTO Categorys(categoryname) VALUES (ADD_new_categoryname);
END //
DELIMITER ;



# 2.3 Lägga till en bloggpost med rubrik, datum och innehåll för en viss skribent
SELECT * FROM Posts;
DROP PROCEDURE IF EXISTS ADD_post;
DELIMITER //
CREATE PROCEDURE ADD_post(ADD_a_id INT,ADD_subject VARCHAR(50),ADD_content VARCHAR(200),ADD_posted DATETIME) # En procedure för att lägga till author_id,subject,content,posted
BEGIN
    INSERT INTO Posts(a_id,subject, content, posted) VALUES (ADD_a_id,ADD_subject,ADD_content,ADD_posted);
END //
DELIMITER ;

# 2.4 Koppla ihop en bloggpost med en kategori
SELECT * FROM Post_categorys;
DROP PROCEDURE IF EXISTS ADD_postcategory;
DELIMITER //
CREATE PROCEDURE ADD_postcategory(ADD_post_cate_id INT,ADD_cate_id INT) # En procedure för att lägga till post_cate_id och cate_id
BEGIN
    INSERT INTO Post_categorys(post_cate_id, cate_id) VALUES (ADD_post_cate_id,ADD_cate_id);
END //
DELIMITER ;

# 2.5 Lägga till en kommentar till ett bloggpost
SELECT * FROM Comments;
DROP PROCEDURE IF EXISTS ADD_comment;
DELIMITER //
CREATE PROCEDURE ADD_comment(ADD_p_id INT,ADD_name VARCHAR(50),ADD_subject VARCHAR(50), ADD_content VARCHAR(200), ADD_posted DATETIME) # En procedure för att lägga till p_id, name, subject,content och posted
BEGIN
    INSERT INTO Comments(p_id,name, subject, content, posted) VALUES (ADD_p_id,ADD_name,ADD_subject,ADD_content,ADD_posted);
END //
DELIMITER ;

# 3 Skapa innehåll
SELECT * FROM Authors;
CALL ADD_author('Ada','Ada Lovelace');
CALL ADD_author('Harper','Harper Andersson');
CALL ADD_author('James','James Karlsson');
CALL ADD_author('Henry','Henry Larsson');
CALL ADD_author('Mia','Mia Nilsson');

SELECT * FROM Categorys;
CALL ADD_category('Red');
CALL ADD_category ('Yellow');
CALL ADD_category ('Blue');
CALL ADD_category ('Crimson');
CALL ADD_category ('Orange');
CALL ADD_category ('Purple');
CALL ADD_category ('Indigo');
CALL ADD_category ('White');
CALL ADD_category ('Violet');
CALL ADD_category ('Green');

SELECT * FROM Posts;
CALL ADD_post(1,'natoque', 'Thanks for your letter!', '2022-01-03 16:20:36');
CALL ADD_post(2,'primis in', 'Have a nice day!', '2022-02-02 12:22:30');
CALL ADD_post(2,'dictumst', 'Proin INTerdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue.', '2021-02-04 18:30:35');
CALL ADD_post(1,'ipsum primis', 'Donec posuere metus vitae ipsum. Aliquam non mauris.', '2012-09-04 09:45:30');
CALL ADD_post(1,'pede', 'Pellentesque ultrices mattis odio.', '2018-06-17 14:20:30');
CALL ADD_post(3,'vel ipsum', 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.', '2021-10-22 19:15:30');
CALL ADD_post(1,'non sodales', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus.', '2020-11-09 10:24:45');
CALL ADD_post(3,'luctus ultricies', 'Nulla suscipit ligula in lacus', '2019-01-04 15:36:30');
CALL ADD_post(4,'accumsan', 'Nulla nisl. Nunc nisl.', '2017-05-22 18:15:28');
CALL ADD_post(5,'ultricies eu', 'Nunc purus. Phasellus in felis.', '2021-09-28 17:10:40');
CALL ADD_post(5,'nullam', 'Quisque porta volutpat erat', '2022-01-14 13:25:43');

SELECT * FROM Post_categorys;
CALL ADD_postcategory(1,1);
CALL ADD_postcategory(2,4);
CALL ADD_postcategory(2,7);
CALL ADD_postcategory(4,8);
CALL ADD_postcategory(6,2);
CALL ADD_postcategory(8,5);
CALL ADD_postcategory(8,4);
CALL ADD_postcategory(9,10);
CALL ADD_postcategory(9,7);
CALL ADD_postcategory(9,9);

SELECT * FROM Comments;
CALL ADD_comment(2,'Faber Hacquel', 'praesent', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', '2021-11-04 08:47:59');
CALL ADD_comment(2,'Veronika Noorwood', 'maecenas pulvinar', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. INTeger non velit.', '2021-12-31 12:51:41');
CALL ADD_comment(3,'Guglielmo Spiniello', 'convallis', 'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo.', '2021-11-03 23:44:00');
CALL ADD_comment(3,'Josh Dufaur', 'dolor', 'Morbi odio odio, elementum eu, INTerdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat.', '2021-09-19 06:20:59');
CALL ADD_comment(1,'Bertie Grolmann', 'proin at', 'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.', '2021-11-09 21:16:46');
CALL ADD_comment(5,'Gawain Jaumet', 'tempor', 'Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.', '2021-12-08 22:35:42');
CALL ADD_comment(5,'Zea Braunston', 'rutrum at', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', '2021-10-29 07:13:32');
CALL ADD_comment(6,'Mariellen Curtis', 'ac nulla', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices.', '2021-10-08 08:59:32');
CALL ADD_comment(7,'Gillie Ludewig', 'metus arcu', 'Morbi a ipsum. integer a nibh.', '2021-10-11 08:12:32');
CALL ADD_comment(8,'Corissa Rosas', 'nunc', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, INTerdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', '2021-09-26 21:33:55');
CALL ADD_comment(9,'Milly Romer', 'sodales', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. INTeger a nibh.', '2021-09-27 01:00:36');

# 4 Ta bort kategori
SELECT * FROM Categorys;
DROP PROCEDURE IF EXISTS delete_category; # En procedure för att ta bort 'Crimson'
DELIMITER //
CREATE PROCEDURE delete_category(delete_categoryname VARCHAR(50))
BEGIN
    DELETE FROM Categorys WHERE categoryname = delete_categoryname;
END //
DELIMITER ;
CALL delete_category ('Crimson');


# 5 Visa alla kommentarer
SELECT * FROM Comments;
DROP PROCEDURE IF EXISTS show_comments;
DELIMITER //
CREATE PROCEDURE show_comments(ADD_post_id INT) # En procedure för att visa alla kommentarer av post 2
BEGIN
    SELECT * FROM Comments
	WHERE Comments.p_id = ADD_post_id;
END //
DELIMITER ;
CALL show_comments(2);


# 6 Visa aktivitetsnivå
SELECT * FROM Posts;
DROP PROCEDURE IF EXISTS Activity_level; # En procedure för att visa upp authors activity_level
DELIMITER //
CREATE PROCEDURE Activity_level()
BEGIN
      SELECT Authors.fullname,
    CASE
        WHEN
			 COUNT(Posts.id) = 0
		THEN 'not active'
        WHEN
            COUNT(Posts.id) < 3
        THEN 'low'
        WHEN
			 COUNT(Posts.id) < 6
        THEN 'medium'
        WHEN
			COUNT(Posts.id) > 5
        THEN 'high'

END AS activity_level FROM Posts
JOIN Authors ON Authors.id = Posts.a_id
GROUP BY Authors.id;
END //
DELIMITER ;
CALL Activity_level();

# 7 no_of_comments(post_id)
SELECT * FROM Comments;
DROP FUNCTION IF EXISTS nr_of_comments;
DELIMITER //
CREATE FUNCTION nr_of_comments(post_id INT) # En funktion för att visa antalet kommentarer av ett post
RETURNS INT DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE nr_of_comments INT;
	SET nr_of_comments := ( SELECT COUNT(Comments.id) FROM Comments
    WHERE Comments.p_id = post_id);
	RETURN nr_of_comments;
END //
DELIMITER ;
SELECT p_id,nr_of_comments(c.p_id) FROM Comments AS c 
GROUP BY p_id 
Order BY p_id;

# 8 no_of_categories(post_id)
SELECT * FROM Post_categorys;
DROP FUNCTION IF EXISTS nr_of_categories;
DELIMITER //
CREATE FUNCTION nr_of_categories(po_id INT) # En funktion för att visa antalet categories av ett post
RETURNS INT DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE nr_of_categories INT;
	SET nr_of_categories := ( SELECT COUNT(cate_id) FROM Post_categorys
    WHERE Post_categorys.post_cate_id = po_id);
	RETURN nr_of_categories;
END //
DELIMITER ;
SELECT post_cate_id,nr_of_categories(pc.post_cate_id) FROM Post_categorys AS pc 
GROUP BY post_cate_id 
Order BY post_cate_id;

# 9 time_since_posting(DATETIME)
SELECT * FROM Posts;
DROP FUNCTION IF EXISTS time_since_posting;
DELIMITER //
CREATE FUNCTION time_since_posting(published DATETIME) # En funktion för att visa hur länge har en post lagt upp
RETURNS VARCHAR(50) DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE time_since_posting VARCHAR(50);
    IF 
    TIMESTAMPDIFF (HOUR, published, NOW()) <= 0 
    THEN SET time_since_posting = "new";
    ELSEIF 
    TIMESTAMPDIFF (HOUR, published, NOW()) <24
    THEN SET time_since_posting = "less then 1 day";
    ELSE SET time_since_posting = CONCAT (TIMESTAMPDIFF (DAY, published, NOW()), "days");
    END IF;
    RETURN time_since_posting;
END //
DELIMITER ;
SELECT p.id,time_since_posting(posted) AS posted FROM Posts AS p 
Order BY posted DESC;

# 10 all_posts
# En view visar all_posts
DROP VIEW IF EXISTS all_posts;
CREATE VIEW all_posts AS
SELECT a.fullname AS Name, Posts.id AS id, Posts.subject AS Heading, time_since_posting(Posts.posted) AS Time_status,
nr_of_comments(c.p_id) AS Comments, nr_of_categories(pc.post_cate_id) AS Categories 
FROM Posts
JOIN Authors a ON a.id = Posts.a_id
JOIN Comments c ON c.p_id = Posts.id
JOIN Post_categorys pc ON pc.post_cate_id = Posts.id
JOIN Categorys ca ON ca.id = pc.cate_id;
SELECT * FROM all_posts ORDER BY id ASC;

# Egen procedure
# Skapa en procedure för att lägga till en new post och category samtidigt
SELECT * FROM Posts;
DROP PROCEDURE IF EXISTS new_post;
DELIMITER //
CREATE PROCEDURE new_post(ADD_a_id INT,ADD_subject VARCHAR(50),ADD_content TEXT,ADD_posted DATETIME,ADD_post_cate_id INT,ADD_cate_id INT)
BEGIN
    CALL ADD_post(ADD_a_id,ADD_subject,ADD_content,ADD_posted);
    CALL ADD_postcategory(ADD_post_cate_id,ADD_cate_id);
END //
DELIMITER ;
CALL new_post(5,'feeling', 'I feel really happy today and thanks for coming!','2022-03-14 13:22:33',3,6);

# Egen trigger
# Skapa en trigger för att inte skriva posts i framtiden
# Skriver error message om poster skriver i framtiden
DROP PROCEDURE IF EXISTS erromessage;
DELIMITER //
CREATE PROCEDURE erromessage (datum DATETIME)
BEGIN
	IF datum > now() THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Det går inte att skriva i framtiden!';
    END IF;
    END //
DELIMITER ;
# Trigger för en Insert
DROP TRIGGER IF EXISTS datum_trigger;
DELIMITER //
CREATE TRIGGER datum_trigger
BEFORE INSERT ON Posts FOR EACH ROW
BEGIN
CALL erromessage(new.posted);
END //
DELIMITER ;
# Trigger för en Update
DROP TRIGGER IF EXISTS new_datum_trigger;
DELIMITER //
CREATE TRIGGER new_datum_trigger
BEFORE UPDATE ON Posts FOR EACH ROW
BEGIN
CALL erromessage(new.posted);
END //
DELIMITER ;
# Ett test för att visa ett fel meddelande
SELECT * FROM posts;
UPDATE Posts
SET posted = '2444-03-14 13:22:33'
WHERE id = 5;