DROP DATABASE lab5;
CREATE DATABASE lab5;
USE lab5;


DROP TABLE IF EXISTS Users;
CREATE TABLE Users (
	id int primary key auto_increment,
    username varchar(50) not null unique
    );

Insert INTO Users (id, username) VALUES (1,'aha12'), (2,'fjk34'), (3,'wth334'),(4,'sddt004'),(5,'lots456'),(6,'zcvs348');
DROP TABLE IF EXISTS Accounts;
CREATE TABLE Accounts (
	id int primary key auto_increment,
    amount int not null
    );

    
Insert INTO Accounts (id, amount) VALUES (1,300000), (2,1000000), (3,750000),(4,460800),(5,550000),(6,687890),
(7,305000), (8,1003000), (9,7770000),(10,467890),(11,557000),(12,688890);

DROP TABLE IF EXISTS Transfers;   
CREATE TABLE Transfers (
	id int primary key auto_increment,
    account_id int not null references Accounts(id),
    amount int not null,
    note text,
    t_datetime datetime default now() not null
    );
Insert INTO Transfers (account_id,amount,note) VALUES (1,300000,'amount is > 0'),(2,1000000,'amount is > 0'),(12,688890,'amount is > 0'),
(4,460800,'amount is > 0'),(7,305000,'amount is > 0'),(9,7770000,'amount is > 0'),(8,1003000,'amount is > 0'),(10,467890,'amount is > 0'),
(3,750000,'amount is > 0'),(5,550000,'amount is > 0'),(6,687890,'amount is > 0'),(11,557000,'amount is > 0');

DROP TABLE IF EXISTS Owners;
CREATE TABLE Owners (
	user_id int not null references Users(id),
    account_id int not null references Accounts(id)
    );

ALTER TABLE Owners
    ADD CONSTRAINT fk_user_id
	FOREIGN KEY (user_id) REFERENCES Users(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE;
    
ALTER TABLE Owners
    ADD CONSTRAINT fk_account_id
	FOREIGN KEY (account_id) REFERENCES Accounts(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE;
    
Insert INTO Owners (user_id, account_id) VALUES (1,1),(2,3),(3,4),(4,6),(5,5),(6,2),(1,7),(2,9),(3,12),(4,11),(5,8),(6,10),
(4,1),(6,3),(2,4),(3,6),(3,5),(6,7);




#Skriv och kör queries för att fylla på med minst 5 användare med minst två konton vardera.
#Välj godtyckliga rimliga värden för belopp som finns för konton. 
#Gör så att minst 2 konton har mer än en ägare.

#Skapa en vy som innehålller kolumer med data från users och
# accounts som visar vilka konton som hör till en user och hur mycket pengar som finns på kontot. 
#Vi vill visa user_id, user_name, account_id och account_amount.
#Ska kunna användas med t ex SELECT * FROM users_accounts WHERE user_id = 3 ORDER BY account_id ASC; 
#eller SELECT user_id FROM users_accounts WHERE account_id = 7;

DROP VIEW IF EXISTS users_accounts;
CREATE VIEW users_accounts AS
	SELECT users.id as user_id, username as user_name, accounts.id as account_id, accounts.amount as account_amount
	FROM Users

	JOIN Owners ON Owners.user_id = Users.id
    JOIN Accounts ON Accounts.id= Owners.account_id;
	
SELECT * FROM users_accounts;
SELECT * FROM users_accounts WHERE user_id = 3 ORDER BY account_id ASC; 
SELECT user_id FROM users_accounts WHERE account_id = 7;

#deposit(account_id, amount)
#Skriv en procedure som lägger till pengar till ett konto. konto 1 :300000+1000
#Procedure ska ändra pengar på konto samt också lägga till en rad i transfers med notering om 
#att det är en insättning, på hur mycket och tid och datum för insättningen. 
#Det ska endast gå att göra insättningar med positiva tal och till konton som redan finns. 
#Endast insättningar som är godkända ska loggas i transfers.
#Använd TRANSACTION och COMMIT så att det inte kan bli fel vid drift. 
# Avsluta med ett SELECT som visar på aktuell rad i transfers om allt gick igenom annars gör 
#SELECT med ett status som är ett meddelande om "Error: acoount does not exist" eller
#"Error: amount is not > 0" som sätts i procedure.

#START TRANSACTION;
#SELECT * FROM accounts;
#INSERT INTO accounts (id, amount) VALUES (123, 3918.31);
#SELECT * FROM accounts;
#ROLLBACK;

SELECT * FROM accounts;
DROP PROCEDURE IF EXISTS add_transfer;
DELIMITER //
CREATE PROCEDURE add_transfer (IN account_id INT, IN new_amount INT)
BEGIN
	SET @new_input_id := (SELECT id FROM Accounts WHERE id = account_id);
	#DECLARE new_input_id INT;
	#SELECT id FROM Accounts WHERE id = account_id INTO new_input_id;
    IF @new_input_id != account_id THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'account does not exist';
    ELSEIF new_amount <= 0 THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'amount is not > 0';
END IF;
END//
DELIMITER ;
CALL add_transfer(13,300000);



