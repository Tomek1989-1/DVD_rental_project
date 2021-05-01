/* Question 1: */
WITH sub AS
  (SELECT DISTINCT f.title AS film_title,
                   c.name AS category_name,
                   COUNT(rental_date)OVER(PARTITION BY f.film_id) AS rental_count
   FROM category AS c
   FULL JOIN film_category AS fc ON c.category_id = fc.category_id
   FULL JOIN film AS f ON fc.film_id = f.film_id
   FULL JOIN inventory AS i ON i.film_id = f.film_id
   FULL JOIN rental AS r ON i.inventory_id = r.inventory_id
   WHERE c.name = 'Animation'
     OR c.name = 'Children'
     OR c.name = 'Classics'
     OR c.name = 'Comedy'
     OR c.name = 'Family'
     OR c.name = 'Music'
   ORDER BY 1)
SELECT category_name,
       SUM(rental_count)
FROM sub
GROUP BY 1
ORDER BY 2 DESC;

/* Question 2: */
WITH sub AS
  (SELECT f.title AS film_title,
          c.name AS category_name,
          f.rental_duration AS rental_duration,
          NTILE(4)OVER(ORDER BY f.rental_duration) AS NTILE
   FROM film AS f
   JOIN film_category AS fc ON f.film_id = fc.film_id
   JOIN category AS c ON c.category_id = fc.category_id),
     sub2 AS
  (SELECT *
   FROM sub
   WHERE category_name = 'Animation'
     OR category_name = 'Children'
     OR category_name = 'Classics'
     OR category_name = 'Comedy'
     OR category_name = 'Family'
     OR category_name = 'Music')
SELECT ntile,
       COUNT(ntile)
FROM sub2
GROUP BY 1
ORDER BY 1;

/* Question 3: */
WITH sub AS
  (SELECT f.title AS film_title,
          c.name AS category_name,
          f.rental_duration,
          NTILE(4)OVER(ORDER BY f.rental_duration) AS standard_quartile
   FROM film AS f
   JOIN film_category AS fc ON f.film_id = fc.film_id
   JOIN category AS c ON c.category_id = fc.category_id),
     sub2 AS
  (SELECT *
   FROM sub
   WHERE category_name = 'Animation'
     OR category_name = 'Children'
     OR category_name = 'Classics'
     OR category_name = 'Comedy'
     OR category_name = 'Family'
     OR category_name = 'Music')
SELECT category_name,
       standard_quartile,
       COUNT(*)
FROM sub2
GROUP BY 1,2
ORDER BY 1,2;