SELECT 
    customer_id,
    monetary AS total_spent,

    CASE 
        WHEN r_score = 5 AND f_score >= 4 THEN 'Champions'
        WHEN r_score >= 4 AND f_score >= 3 THEN 'Loyal Customers'
        WHEN r_score <= 2 THEN 'At Risk'
        ELSE 'Regular Customers'
    END AS customer_segment

FROM (
    SELECT 
        customer_id,
        recency,
        frequency,
        monetary,

        NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency) AS f_score,
        NTILE(5) OVER (ORDER BY monetary) AS m_score

    FROM (
        SELECT 
            customer_id,
            DATEDIFF('2024-03-31', MAX(order_date)) AS recency,
            COUNT(order_id) AS frequency,
            SUM(amount) AS monetary
        FROM orders
        GROUP BY customer_id
    ) AS rfm
) AS scored;