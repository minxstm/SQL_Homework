Use sakila;

#1a. Display the first and last names of all actors from the table `actor`. 
first_name, last_name
from actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`. 
select upper(concat(first_name," ",last_name)) as Actor_Name
from actor;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select
first_name, last_name, actor_id
from actor 
where first_name like "Joe";

#2b. Find all actors whose last name contain the letters `GEN`:
select
first_name, last_name, actor_id
from actor 
where last_name like "%Gen%";

#2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
select
first_name, last_name, actor_id
from actor 
where last_name like "%Li%"
order by last_name, first_name;

#2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country
from country
where country in ("Afghanistan", "Bangladesh", "China");

#3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.
alter table actor
add column middle_name varchar(255) 
after first_name;

describe actor;

#3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.
alter table actor
drop column middle_name
add column middle_name blob
after first_name;=p-o09uytdr2s	
describe actor;

#3c. Now delete the `middle_name` column.
alter table actor
drop column middle_name

#Q
SELECT last_name, count(last_name) AS 'count'
FROM actor
GROUP BY last_name;

#4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) AS "count"
from actor
group by last_name;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(last_name) as
'count'
from actor
group by last_name
having count >= 2;

#4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
update actor
set first_name = "harpo"
where first_name = "groucho"
and last_name = "williams";

#4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)
update actor
set first_name = "harpo"
where actor_id = 172;

#5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it? 
show create table address;

#6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
select first_name, last_name, address
from staff as s
inner join address as a
on (s.address_id = a.address_id);

#6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. 
select first_name, last_name, sum(amount)
from staff as s
inner join payment as p
on (p.staff_id = s.staff_id)
where payment_date like "%2005%";

#6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
select title, count(actor_id)
from film_actor as fa
inner join film as f
on (f.film_id = fa.film_id)
group by f.title;

#6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select title, count(inventory_id) as 
'count'
from film as f
inner join inventory as i
on (f.film_id = i.film_id)
where title = "Hunchback Impossible";

#6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
select first_name, last_name, sum(amount) as
'total'
from payment as p
join customer as c
on p.customer_id = c.customer_id
group by c.customer_id;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. 
select title
from film
where title like "k%"
or title like "q%"
and language_id in
(	
    select language_id
    from film
    where language_id = "English"
);

#7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
select first_name, last_name
from actor
where actor_id in 
(
	select actor_id
	from film_actor
	where film_id =
	(	
		select film_id
        from film
        where title = "Alone Trip"
	)
);

#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select first_name, last_name,email, country
from customer as c
join address as a
on (c.address_id = a.address_id)
join city 
on (a.city_id = city.city_id)
join country as ct
on (city.country_id = ct.country_id)
where ct.country = "Canada"; 

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
select title
from film as f
join film_category as c
on (f.film_id = c.film_id);

#7e. Display the most frequently rented movies in descending order.
select title, count(title) as
'count'
from film as f
join inventory as i
on (f.film_id = i.film_id)
join rental as r
on (i.inventory_id = r.inventory_id)
group by title
order by count desc;

#7f. Write a query to display how much business, in dollars, each store brought in.
select s.store_id, sum(amount) as 
'total'
from payment as p
join rental as r
on (p.rental_id = r.rental_id)
join inventory as i
on (i.inventory_id = r.inventory_id)
join store as s
on (s.store_id = i.store_id)
group by s.store_id;

#7g. Write a query to display for each store its store ID, city, and country.
select store_id, a.city_id, address, address2
from store as s
join address as a
on (s.address_id = a.address_id);

#7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
