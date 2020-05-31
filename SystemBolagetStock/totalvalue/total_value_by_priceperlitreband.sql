SELECT 
    CONCAT(rangestart, ' - ', rangestart + 99) AS "Price Band Text",
    rangestart AS "Price Band Start",
    sekvalue AS "SEK Value"
FROM (
    SELECT
        SUM(article.price * totalstock.quantity) AS sekvalue,
        LEAST(priceperlitre - (priceperlitre % 100), 4000) as rangestart
        FROM article
        INNER JOIN totalstock
            ON article.articleid = totalstock.articleid
        GROUP BY rangestart
        ORDER BY rangestart ASC
    ) AS article_and_stock
