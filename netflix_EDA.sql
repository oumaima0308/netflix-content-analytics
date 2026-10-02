create database netflix_bi;
use netflix_bi ;

create table content(
     show_id VARCHAR(10) primary key,
     title varchar(255) not null ,
     type     varchar(20) not null ,
     date_added date ,
     release_year INT,
     rating varchar(20),
     duration_value int ,
     duration_unit varchar(20),
     director TEXT,
     cast text,
     description text
);

create table countries (
       country_id int primary key , 
       country varchar(100) not null 
);       

create table categories (
        category_id int primary key,
        listed_in varchar(100) not null
);      

create table content_country (
      show_id varchar(10),
      country_id int ,
      primary key (show_id,country_id),
      foreign key (show_id)
         references content(show_id),
      foreign key (country_id)
         references countries(country_id)
);         

create table content_category (
       show_id varchar(10),
       category_id int ,
       primary key (show_id , category_id),
       
       foreign key (show_id)
           references content(show_id),
           
       foreign key(category_id)
           references categories(category_id)
           
);           
       
       
SHOW TABLES;  

describe content ;
DESCRIBE countries;
DESCRIBE categories;
DESCRIBE content_country;
DESCRIBE content_category;

SHOW CREATE TABLE content_country;   
SHOW CREATE TABLE content_category;

SELECT COUNT(*) AS total_countries
FROM countries;

SELECT COUNT(*) AS total_categories
FROM categories;


SELECT COUNT(*) AS total_content
FROM content;
     
SELECT COUNT(*) AS total_relations
FROM content_country;


SELECT COUNT(DISTINCT show_id) AS unique_contents
FROM content_country;


-- Quelle est la répartition entre Movies et TV Shows dans le catalogue ?
SELECT
    type,
    COUNT(*) AS total_content,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM content
GROUP BY type
ORDER BY total_content DESC;

-- Combien de contenus ont été ajoutés au catalogue chaque année ?

SELECT
    YEAR(date_added) AS year_added,
    COUNT(*) AS content_added
FROM content
WHERE date_added IS NOT NULL
GROUP BY YEAR(date_added)
ORDER BY year_added;

-- Quelles catégories sont les plus représentées dans le catalogue Netflix ?

SELECT
    c.listed_in AS category,
    COUNT(*) AS content_count
FROM content_category cc
JOIN categories c
    ON cc.category_id = c.category_id
GROUP BY c.listed_in
ORDER BY content_count DESC;
     
-- Quelle est la répartition des classifications d'âge des contenus ?      

SELECT
    rating,
    COUNT(*) AS content_count
FROM content
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY content_count DESC;


--  La répartition des ratings est-elle différente entre Movies et TV Shows ? 

SELECT
    type,
    rating,
    COUNT(*) AS content_count
FROM content
WHERE rating IS NOT NULL
GROUP BY type, rating
ORDER BY type, content_count DESC;


-- Quels pays sont associés au plus grand nombre de contenus ?

 SELECT
    c.country,
    COUNT(*) AS content_count
FROM content_country cc
JOIN countries c
    ON cc.country_id = c.country_id
GROUP BY c.country
ORDER BY content_count DESC
LIMIT 10;
 
 
-- Pour les principaux pays, quelle est la répartition entre Movies et TV Shows ? 

SELECT
    ctry.country,
    c.type,
    COUNT(*) AS content_count
FROM content_country co
JOIN countries ctry
    ON co.country_id = ctry.country_id
JOIN content c
    ON co.show_id = c.show_id
GROUP BY ctry.country, c.type
ORDER BY ctry.country, content_count DESC;


-- Les catégories diffèrent-elles entre Movies et TV Shows ?

SELECT
    co.type,
    ca.listed_in AS category,
    COUNT(*) AS content_count
FROM content_category cc
JOIN content co
    ON cc.show_id = co.show_id
JOIN categories ca
    ON cc.category_id = ca.category_id
GROUP BY co.type, ca.listed_in
ORDER BY co.type, content_count DESC;

-- Quelle est la distribution de la durée des Movies et du nombre de saisons des TV Shows ?
SELECT
    ROUND(AVG(duration_value), 1) AS avg_movie_duration,
    MIN(duration_value) AS min_movie_duration,
    MAX(duration_value) AS max_movie_duration
FROM content
WHERE type = 'Movie'
  AND duration_unit = 'min';


SELECT
    ROUND(AVG(duration_value), 1) AS avg_seasons,
    MIN(duration_value) AS min_seasons,
    MAX(duration_value) AS max_seasons
FROM content
WHERE type = 'TV Show'
  AND duration_unit = 'season';  
  
  

