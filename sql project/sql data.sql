
-- Retrieve all columns fromo the table--------------

select * from wsdemo1.adidas_vs_nike;

-- Altering the table, like changing th names of the columns----------------

ALTER TABLE wsdemo1.adidas_vs_nike
CHANGE COLUMN `Last_visited` `Last_visited` DATETIME,
CHANGE COLUMN `Product Name` `Product_Name` VARCHAR(255),
CHANGE COLUMN `Product ID` `Product_ID` VARCHAR(255),
CHANGE COLUMN `Sale Price` `Sale_Price` DECIMAL(10, 2),
CHANGE COLUMN `Listing Price` `Listing_Price` DECIMAL(10, 2);

commit;
rollback;

Select Description from wsdemo1.adidas_vs_nike;

-- cleaning some of the values in the columns-----------

UPDATE wsdemo1.adidas_vs_nike
SET Brand = 'Adidas ORIGINALS'
WHERE Brand = 'Adidas Adidas ORIGINALS'
LIMIT 1;

select * from wsdemo1.adidas_vs_nike;

-- select Description, Brand from wsdemo1.adidas_vs_nike where Brand like "%ORIGINALS%";

-- ========================================================================================================

-- =============total number of sales on the date for each brand======================
SELECT Brand,date(Last_visited) AS month, 
       SUM(Sale_Price) AS total_sales
FROM wsdemo1.adidas_vs_nike
GROUP BY month, Brand;  

-- ==================avg dicount and avg rating for brand to analyze brand performance================

SELECT brand, SUM(sale_price) AS total_sales, 
avg(Discount) as Discount, round(AVG(rating),2) AS avg_rating 
FROM wsdemo1.adidas_vs_nike GROUP BY brand;

-- ===============average pricing for brand wise====================

select brand, avg(listing_price) as avg_listing_price, avg(sale_price) as avg_sale_price
from wsdemo1.adidas_vs_nike group by brand;

-- ==================highest sales from all brands==================

SELECT product_id, product_name, brand, SUM(sale_price) AS sales
FROM wsdemo1.adidas_vs_nike
GROUP BY product_id, product_name, brand
ORDER BY sales desc;

-- ================top 5 sales in each brand=====================

SELECT 
    t.product_id,
    t.product_name,
    t.brand,
    t.sale_price
FROM wsdemo1.adidas_vs_nike t
WHERE (
    SELECT COUNT(*) 
    FROM wsdemo1.adidas_vs_nike 
    WHERE brand = t.brand AND sale_price >= t.sale_price
    order by brand
) <= 5;

-- ================average visited time for each brand================

SELECT
    brand,
    FROM_UNIXTIME(AVG(UNIX_TIMESTAMP(last_visited))) AS avg_last_visited
FROM
    wsdemo1.adidas_vs_nike
GROUP BY
    brand;
    
-- ====================visiting count w.r.t each minute=====================

SELECT
    DATE_FORMAT(last_visited, '%h:%i %p') AS visit_time,
    COUNT(*) AS visit_count
FROM
    wsdemo1.adidas_vs_nike
GROUP BY
    visit_time
ORDER BY
    visit_count DESC;

-- ==============total number of sales w.r.t each minute==============

SELECT
  DATE_FORMAT(last_visited, '%Y-%m-%d %H:%i') AS minute,
  SUM(sale_price) AS total_sales,
 avg(sale_price) as average_sales,
 avg(discount) as average_discount
FROM
  wsdemo1.adidas_vs_nike
GROUP BY
  minute
ORDER BY
  total_sales DESC;

-- ==================discount impact on sales=====================

SELECT
Brand,
avg(sale_price) as average_sales,
 avg(discount) as average_discount
FROM
    wsdemo1.adidas_vs_nike
GROUP BY
    brand;
    
  -- ==============sales after discount w.r.t minutes============  
    
    SELECT
  DATE_FORMAT(last_visited, '%Y-%m-%d %H:%i') AS minute,
  SUM(sale_price * (1 - discount)) AS total_sales_after_discount
FROM
  wsdemo1.adidas_vs_nike
GROUP BY
  minute
ORDER BY
  total_sales_after_discount DESC;

-- ==============Highest discount with highest sales================

SELECT
  brand,
  MAX(discount) AS highest_discount,
  SUM(sale_price * (1 - discount/100)) AS total_sales_after_discount
FROM
   wsdemo1.adidas_vs_nike
GROUP BY
  brand
ORDER BY
  total_sales_after_discount DESC;

-- =========impact of sales w.r.t discount for each brand==============

SELECT
  brand,
  discount,
  COUNT(*) AS sales_count
FROM
  wsdemo1.adidas_vs_nike
GROUP BY
  discount, brand
ORDER BY
  discount;