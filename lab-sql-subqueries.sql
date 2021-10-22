-- 1.How many copies of the film Hunchback Impossible exist in the inventory system?
select count(distinct(inventory_id)) as filmCopies
from  sakila.inventory
where film_id =(
select film_id from sakila.film where title="Hunchback Impossible");

-- 2.List all films whose length is longer than the average of all the films.
select title from sakila.film
where length > (select avg(length) from sakila.film)
order by length desc;

-- 3.Use subqueries to display all actors who appear in the film Alone Trip.
select concat(first_name, ' ', last_name) as actorName
from sakila.actor
where actor_id in (select actor_id from sakila.film_actor
where film_id =(select film_id from sakila.film where title = "Alone Trip"));

-- 4.Sales have been lagging among young families, 
-- 		and you wish to target all family movies for a promotion. 
-- 		Identify all movies categorized as family films.
select title from sakila.film where film_id in (
select film_id from sakila.film_category where category_id =
(select category_id from sakila.category where name = "Family"));

-- 5.Get name and email from customers from Canada using subqueries. 
select concat(first_name, ' ', last_name) as Name, email
from sakila.customer
where address_id in (
select address_id from sakila.address where city_id in
(select city_id from sakila.city where country_id = 
(select country_id from sakila.country where country="Canada")))
;
-- 		Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary 
-- 			keys and foreign keys, that will help you get the relevant information.
select concat(first_name, ' ', last_name) as Name, email
from sakila.customer
join sakila.address using (address_id)
join sakila.city using (city_id)
join sakila.country using (country_id)
where country="Canada";

-- 6.Which are films starred by the most prolific actor? Most prolific actor is defined 
-- 		as the actor that has acted in the most number of films. First you will have to 
-- 		find the most prolific actor and then use that actor_id to find the different 
-- 		films that he/she starred.
select title from sakila.film
where film_id in (
select film_id from sakila.film_actor
where actor_id = (
select actor_id from sakila.film_actor
group by actor_id
order by count(film_id) desc
limit 1));
-- 6.Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer 
-- 		ie the customer that has made the largest sum of payments

select title
from sakila.film f
join sakila.inventory i using (film_id)
join sakila.rental r using (inventory_id)
where r.customer_id=(
select customer_id
from sakila.payment
group by customer_id
order by sum(amount) desc
limit 1)
;
-- 7.Customers who spent more than the average payments.

select concat(first_name,' ',last_name) as customerName, sum(amount) as spend
from sakila.payment
join sakila.customer using (customer_id)
group by customer_id
having spend > (
select avg(spend) from (
select customer_id, sum(amount) as spend
from sakila.payment
group by customer_id)s1)
order by spend
;