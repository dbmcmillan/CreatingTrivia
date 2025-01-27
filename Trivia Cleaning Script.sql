-- Create table
CREATE TABLE trivia (
    id INT PRIMARY KEY AUTO_INCREMENT,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    topic VARCHAR(255),
    difficulty_level VARCHAR(50)
);

-- Load data from CSV
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/AItrivia.csv"
INTO TABLE trivia
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(question, answer, topic, difficulty_level);

-- Remove exact duplicates (same question and answer)
DELETE t1
FROM trivia t1
INNER JOIN trivia t2 
    ON t1.question = t2.question 
    AND t1.answer = t2.answer 
    AND t1.id > t2.id;

-- Remove answer-based duplicates
DELETE t1
FROM trivia t1
INNER JOIN trivia t2 
    ON t1.answer = t2.answer 
    AND t1.id > t2.id;

-- Remove question-based duplicates
DELETE t1
FROM trivia t1
INNER JOIN trivia t2 
    ON t1.question = t2.question 
    AND t1.id > t2.id;

-- Still one row that says no question generated, so since we don't want that I delete it as well
DELETE from trivia WHERE question = "No question generated";

-- Noticing a lot of variations of the answer "Planck's constant", so writing code to delete as many duplicates as possible, leaving the answer "Planck's constant" in the table.
DELETE FROM trivia WHERE answer LIKE "Planck's constant %";
DELETE FROM trivia WHERE answer LIKE "Planck's constant.%";
DELETE FROM trivia WHERE answer = "The constancy of the speed of light.";

DELETE FROM trivia WHERE answer LIKE "The Russian Revolution %";
DELETE FROM trivia WHERE answer = "The Russian Revolution.";

SELECT * FROM trivia;

-- Export cleaned data to CSV
SELECT 
    REPLACE(REPLACE(question, '"', '""'), '\\', '') AS question,
    REPLACE(REPLACE(answer, '"', '""'), '\\', '') AS answer,
    topic,
    difficulty_level
FROM trivia
INTO OUTFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CleanedTrivia.csv"
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\r\n';