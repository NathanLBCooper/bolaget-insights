SELECT 
    category as "Category",
    sekvalue as "SEK Value"
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (ORDER BY sekvalue DESC) AS rank
        FROM
        (
            SELECT
                article.Category,
                SUM(article.price * totalstock.quantity) AS sekvalue
                FROM article
                INNER JOIN totalstock
                    ON article.articleid = totalstock.articleid
                GROUP BY article.Category
        ) AS article_and_stock
    ) AS withrownum
ORDER BY rank ASC
