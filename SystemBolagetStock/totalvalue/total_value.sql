SELECT 
    fullname as "Full Name",
    category as "Category",
    sekvalue as "SEK Value",
    price,
    quantity,
    articleId
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (ORDER BY sekvalue DESC) AS rank
        FROM
        (
            SELECT
                article.articleid,
                CONCAT(article.name, ' ', article.name2) AS fullname,
                article.Category,
                article.price * totalstock.quantity AS sekvalue,
                article.price,
                totalstock.quantity
                FROM article
                INNER JOIN totalstock
                    ON article.articleid = totalstock.articleid
        ) AS article_and_stock
    ) AS withrownum
ORDER BY rank ASC