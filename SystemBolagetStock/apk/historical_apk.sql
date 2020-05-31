--  Historical APK.
-- Show a leader board with changes from the last 30 days.

SELECT 
    "Rank",
    "Old Rank" - "Rank" AS "Change",
    "Full Name",
    "Category",
    "Alcohol",
    "Price per litre"
FROM (
SELECT
    ROW_NUMBER() OVER (ORDER BY "Price per litre of alcohol", articleId ASC) AS "Rank",
    ROW_NUMBER() OVER (ORDER BY "Old Price per litre of alcohol", articleId ASC) AS "Old Rank",
    *
    FROM
    (
        SELECT
            article.articleId,
            CONCAT(article.name, ' ', article.name2) AS "Full Name",
            article.category AS "Category",
            article.alcohol AS "Alcohol",
            old.alcohol AS "Old Alcohol",
            article.priceperlitre AS "Price per litre",
            old.priceperlitre AS "Old Price per litre",
            (article.priceperlitre * 100) / (SUBSTR(article.alcohol, 1, LENGTH(article.alcohol) - 1)::NUMERIC) AS "Price per litre of alcohol",
            (old.priceperlitre * 100) / (SUBSTR(old.alcohol, 1, LENGTH(old.alcohol) - 1)::NUMERIC) AS "Old Price per litre of alcohol"
            FROM article
            INNER JOIN totalstock
                ON totalstock.articleId = article.articleId
            LEFT JOIN (
                    SELECT * FROM article_with_history WHERE sys_period @> NOW() - INTERVAL '30 DAYS'
                ) AS old
                ON article.articleId = old.articleId
            WHERE
                article.expired = FALSE
                -- and because non-alcoholic alternatives have an infinite "Price per litre of alcohol":
                AND (SUBSTR(article.alcohol, 1, LENGTH(article.alcohol) - 1)::NUMERIC) > 0
                AND totalstock.quantity > 0
        ) AS article_with_apk
) AS article_with_apk_rank
ORDER BY "Rank" ASC
