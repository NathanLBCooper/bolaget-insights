SELECT 
    fullname as "Full Name",
    category as "Category",
    sekvalue as "Current SEK Value",
    lastweeksekvalue as "Last Weeks SEK Value",
    sekvalue - lastweeksekvalue as "Change in SEK Value",
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
                totalstock.quantity,
                lastweek.sekvalue AS lastweeksekvalue
                FROM article
                INNER JOIN totalstock
                    ON article.articleid = totalstock.articleid
                LEFT JOIN
                    (SELECT * FROM (
                        SELECT
                            article_with_history.articleid,
                            article_with_history.price * totalstock_with_history.quantity AS sekvalue
                            FROM article_with_history
                            INNER JOIN totalstock_with_history
                                ON article_with_history.articleid = totalstock_with_history.articleid
                            WHERE article_with_history.sys_period @> NOW() - INTERVAL '7 DAYS'
                                AND totalstock_with_history.sys_period @> NOW() - INTERVAL '7 DAYS'
                    ) AS l ) AS lastweek
                    ON article.articleId = lastweek.articleId
        ) AS multipledates
    ) AS withrownum
ORDER BY rank ASC
