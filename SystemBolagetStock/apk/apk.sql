-- APK. Order the inventory of Systemet from top to bottom using the classic alcoholics' guide to value

SELECT * FROM (
SELECT
    ROW_NUMBER() OVER (ORDER BY "Price per litre of alcohol" ASC) AS "Rank",
    *
    FROM
    (
        SELECT
            CONCAT(article.name, ' ', article.name2) AS "Full Name",
            article.category AS "Category",
            article.alcohol AS "Alcohol",
            article.priceperlitre AS "Price per litre",
            (article.priceperlitre * 100) / (SUBSTR(article.alcohol, 1, LENGTH(article.alcohol) - 1)::NUMERIC) AS "Price per litre of alcohol"
            FROM article
            INNER JOIN totalstock
                ON totalstock.articleId = article.articleId
            WHERE
                article.expired = FALSE
                -- and because non-alcoholic alternatives have an infinite "Price per litre of alcohol":
                AND (SUBSTR(article.alcohol, 1, LENGTH(article.alcohol) - 1)::NUMERIC) > 0
                AND totalstock.quantity > 0
        ) AS article_with_apk
) AS article_with_apk_rank
ORDER BY "Rank" ASC
