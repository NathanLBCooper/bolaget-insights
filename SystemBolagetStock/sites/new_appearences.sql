SELECT article.articleid,
    storestock.siteId,
    storestock.quantity AS "Current Quantity",
    old.quantity AS "Last Months Quantity"
FROM storestock
    INNER JOIN article
        ON article.articleid = storestock.articleid
    LEFT JOIN (
        SELECT storestock_with_history.articleid,
            storestock_with_history.siteid,
            storestock_with_history.quantity
        FROM  storestock_with_history
        WHERE storestock_with_history.sys_period @> NOW() - INTERVAL '30 DAYS'
    ) AS old 
        ON article.articleid = old.articleId AND storestock.siteid = old.siteid
    WHERE storestock.quantity > 0
        AND coalesce(old.quantity, 0) = 0;
