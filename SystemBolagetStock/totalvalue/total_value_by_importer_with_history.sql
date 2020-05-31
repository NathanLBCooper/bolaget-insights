SELECT 
    importer AS "Importer",
    sekvalue AS "SEK Value",
    lastweeksekvalue AS "Last Week SEK Value",
    lastmonthsekvalue AS "Last Month SEK Value"
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (ORDER BY sekvalue DESC) AS rank
        FROM
        (
            SELECT
                article.importer,
                SUM(article.price * totalstock.quantity) AS sekvalue,
                SUM(lastweek.sekvalue) AS lastweeksekvalue,
                SUM(lastmonth.sekvalue) AS lastmonthsekvalue
                FROM article
                INNER JOIN totalstock
                    ON article.articleid = totalstock.articleid
                LEFT JOIN 
                    (SELECT * FROM (
                            SELECT
                                article_with_history.articleid,
                                article_with_history.importer,
                                article_with_history.price * totalstock_with_history.quantity AS sekvalue
                                FROM article_with_history
                                INNER JOIN totalstock_with_history
                                    ON article_with_history.articleid = totalstock_with_history.articleid
                                WHERE article_with_history.sys_period @> NOW() - INTERVAL '7 DAYS'
                                    AND totalstock_with_history.sys_period @> NOW() - INTERVAL '7 DAYS'
                        ) AS l ) AS lastweek
                    ON article.articleId = lastweek.articleId
                LEFT JOIN 
                    (SELECT * FROM (
                            SELECT
                                article_with_history.articleid,
                                article_with_history.importer,
                                article_with_history.price * totalstock_with_history.quantity AS sekvalue
                                FROM article_with_history
                                INNER JOIN totalstock_with_history
                                    ON article_with_history.articleid = totalstock_with_history.articleid
                                WHERE article_with_history.sys_period @> NOW() - INTERVAL '1 MONTHS'
                                    AND totalstock_with_history.sys_period @> NOW() - INTERVAL '1 MONTHS'
                        ) AS l ) AS lastmonth
                    ON article.articleId = lastmonth.articleId
                GROUP BY article.importer
        ) AS article_and_stock
    ) AS withrownum
ORDER BY rank ASC