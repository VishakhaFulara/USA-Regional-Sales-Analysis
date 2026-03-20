-- Query 1: Calculate overall business performance metrics
-- This query returns the total number of orders, total revenue generated,and total profit earned across all sales transactions.
select count(distinct order_number) as total_number_of_orders,
sum(revenue) as total_revenue,
round(sum(profit),2) as total_profit
from sales;


-- Query 2: Analyzing sales performance across different sales channels
-- Helps to identify which sales channel contributes the highest revenue and profit.
select channel,
round(sum(revenue),2) as revenue,
round(sum(profit),2) as profit
from sales
group by channel
order by Revenue desc;

-- Query 3: Identify the top 10 products generating the highest revenue
-- Useful for understanding which products drive the majority of sales.
select top 10 product_name,
round(sum(revenue),2) as revenue
from sales
group by product_name
order by revenue desc;

-- Query 4: Calculate total revenue generated each month
-- Used to analyze sales trends and identify seasonal patterns.
select year_month,
round(sum(revenue),2) as monthly_revenue
from sales
group by year_month
order by year_month;

-- Query 5: Identify the states contributing the most revenue
-- Helps analyze geographic sales performance.
select top 10 state,
round(sum(revenue),2) as revenue
from sales
group by state
order by revenue desc;

-- Query 6: Identify the top customers based on total revenue generated
-- Helps recognize high-value customers for retention strategies.
select top 10 customer_names,
round(sum(revenue),2) as revenue
from sales
group by customer_names
order by revenue desc;

-- Query 7: Find the top 3 revenue-generating customers in each region
-- Uses a window function (RANK) to rank customers within each region

with customer_rank as(
select region,customer_names,
sum(revenue) as total_revenue,
rank() over(partition by region order by sum(revenue) desc) as rnk
from sales
group by region,customer_names
)

select * from customer_rank
where rnk<=3;

-- Query 8: Segment customers based on their total spending
-- Customers are categorized into High Value, Medium Value, and Low Value groups.
with customer_spending as(
select customer_names,
round(sum(revenue),2) as total_spent
from sales
group by customer_names
)

select *,
case
when NTILE(3) OVER(ORDER BY total_spent DESC) = 1 then 'Low Value'
when NTILE(3) OVER(ORDER BY total_spent DESC) = 2 then 'Medium Value'
else 'High Value'
end as customer_segment
from customer_spending
order by customer_segment;

