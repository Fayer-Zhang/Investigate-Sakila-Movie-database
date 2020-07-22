/*Slide 1*/
SELECT t1.name, t1.standard_quartile, COUNT(t1.standard_quartile)
FROM
	(SELECT f.title, c.name , f.rental_duration, NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
	 FROM category c
	 JOIN film_category fc
	 ON c.category_id = fc.category_id
	 JOIN film f
	 ON f.film_id = fc.film_id
	 WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
	) t1 
GROUP BY 1, 2
ORDER BY 1, 2

/*Slide 2*/
SELECT c.first_name || ' ' || c.last_name AS full_name, SUM(p.amount) AS total_pay_amount
FROM customer c
JOIN payment p
ON p.customer_id = c.customer_id
WHERE c.first_name || ' ' || c.last_name IN
	(SELECT t1.full_name
	 FROM
		(SELECT c.first_name || ' ' || c.last_name AS full_name, SUM(p.amount) as amount_total
		 FROM customer c
		 JOIN payment p
	 	 ON p.customer_id = c.customer_id
		 GROUP BY 1	
		 ORDER BY 2 DESC
		 LIMIT 10) t1
		) 
	AND (p.payment_date BETWEEN '2007-01-01' AND '2008-01-01')
GROUP BY 1
ORDER BY 1


/*Slide 3*/
SELECT actor_name, count_movies
FROM
	(SELECT a.actor_id, a.first_name||' '||a.last_name actor_name, COUNT(*) count_movies
	FROM actor a
	JOIN film_actor fa
	ON a.actor_id=fa.actor_id
	GROUP BY 1,2
	ORDER BY 3 DESC
	LIMIT 5) t1

/*Slide 4*/
WITH flc AS (SELECT film_id, NTILE(10) OVER(ORDER BY length) length_quartile
			 				FROM film)
SELECT length_quartile, COUNT(*) rental_count
FROM flc
JOIN inventory i
ON flc.film_id=i.film_id
JOIN rental r
ON i.inventory_id=r.inventory_id
GROUP BY 1
ORDER BY 1