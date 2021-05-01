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