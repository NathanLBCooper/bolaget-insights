SELECT
    CONCAT(article_with_history.name, ' ', article_with_history.name2, ' (', article_with_history.articleid ,')') AS "Full Name (ArticleId)",
    article_with_history.price * totalstock_with_history.quantity AS "Value in SEK",
    lower(totalstock_with_history.sys_period) AS date
    FROM totalstock_with_history
    INNER JOIN article_with_history
        ON article_with_history.articleid = totalstock_with_history.articleid
            AND article_with_history.sys_period @> lower(totalstock_with_history.sys_period)