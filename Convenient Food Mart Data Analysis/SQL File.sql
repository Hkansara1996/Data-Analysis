
-- Sales, Cost and Profit
SELECT brand_name, food_family, food_category, food_department, sum(store_sales) as sales, sum(store_cost) as costs, sum(store_sales-store_cost) as profit, sum(store_sales-store_cost) *100.0/ (select sum(store_sales-store_cost) from media_prediction_cost) as percentage
FROM media_prediction_cost GROUP BY brand_name ORDER BY sales desc
LIMIT 10;

-- Sum of  Sales, Cost, Units and Profit
SELECT sum(store_sales) as sales, sum(store_cost) as costs, sum(store_sales-store_cost) as profit, sum(unit_sales) as units
FROM media_prediction_cost;

-- Units
SELECT brand_name, food_family, food_category, food_department, sum(unit_sales) as units, sum(unit_sales) *100.0/ (select sum(unit_sales) from media_prediction_cost) as percentage
FROM media_prediction_cost GROUP BY food_department ORDER BY units desc
LIMIT 10;

-- Food Produce esp for vegetables has the highest profit and sale overall along with brand name Hermanos and same for units. 


#Profits by gender
SELECT gender, 
	ROUND(SUM(store_sales) - SUM(store_cost)) as store_profit,
    count(*) * 100.0 / sum(count(*)) over()
FROM media_prediction_cost
GROUP BY 1;
-- Female generate more profits than male 
    
# Profits by houseowner
SELECT houseowner, 
	ROUND(SUM(store_sales) - SUM(store_cost)) as store_profit,
    count(*) * 100.0 / sum(count(*)) over()
FROM media_prediction_cost
GROUP BY 1;
-- Home ownership generate more profits
#Profits by education 
SELECT education,
	ROUND(SUM(store_sales) - SUM(store_cost)) as store_profit
FROM media_prediction_cost
GROUP BY 1;

-- Partial high school spend more money at the convient store than others 
	
#Profits by Avg Income 
SELECT avg_yearly_income,
	ROUND(SUM(store_sales) - SUM(store_cost)) as store_profit
FROM media_prediction_cost
GROUP BY 1;
-- Avg income $10k - $30k generate more profits than others

#Profits by marital status
SELECT marital_status,
	ROUND(SUM(store_sales) - SUM(store_cost)) as store_profit,
    count(*) * 100.0 / sum(count(*)) over()
FROM media_prediction_cost
GROUP BY 1;
-- Single tends to spend more money than married 
#Profits and sales by promotions
SELECT promotion_name, 
	   ROUND(SUM(store_sales)) as store_sales,
	   ROUND(SUM(store_sales) - SUM(store_cost)) as store_profit
FROM media_prediction_cost
GROUP BY 1
ORDER BY 3 DESC;
-- Weekend Markdown promotion has the highest sales and profits compared to others. 


-- profit per city
drop table city_profit;
create table city_profit as 
select row_number() over() as id, 
	`store_sales` as sales, 
    `store_cost` as cost, 
    round((`store_sales` - `store_cost`), 2) as profit, 
    sales_country as country, 
    store_state as state, 
    store_city as city    
    from media_prediction_cost;
    
    select * from city_profit;
    
    
 -- profit per country
    select 
		round(sum(sales), 2) as total_sales, 
		round(sum(cost),2) as total_cost, 
		round(sum(profit),2) as total_profit, 
        city,
        state, 
        country,
       sum(profit) * 100/(select sum(profit) from city_profit) as percent
        from city_profit 
    group by country
    order by sum(profit) desc;
    
	-- profit per city
    select 
		round(sum(sales), 2) as total_sales, 
		round(sum(cost),2) as total_cost, 
		round(sum(profit),2) as total_profit, 
        city,
        state, 
        country,
       sum(profit) * 100/(select sum(profit) from city_profit) as percent
        from city_profit 
    group by city
    order by sum(profit) desc;
    
-- profit per store
drop table store_profit;
create table store_profit as 
select row_number() over() as id, 
	`store_sales` as sales, 
    `store_cost` as cost, 
    round((`store_sales` - `store_cost`), 2) as profit, 
    sales_country as country,
    store_type    
    from media_prediction_cost;
     
     
 select * from store_profit;
    select store_type,
		sum(profit) * 100/(select sum(profit) from store_profit) as percent
        from store_profit
        group by store_type
        order by sum(profit) desc;
	
    -- Tacoma, Washington, USA has the highest sales and profit as well as Supermarket stores