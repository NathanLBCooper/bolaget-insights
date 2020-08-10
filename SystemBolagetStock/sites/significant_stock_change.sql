-- UNIT COUNT BASED
-- @significantVolumeChange, miniumum increase in the number of units to be counted as a new apperence
SELECT article.articleid,
    CONCAT(article.name, ' ', article.name2) AS "Full Name",
    storestock.siteId,
    CONCAT(store.name, ' ', store.address1) AS "Store",
    store.wgs84coordinates[0] as "longitude",
    store.wgs84coordinates[1] as "latitude",
    storestock.quantity AS "Current Quantity",
    storestock.quantity * article.price AS "Current SEK Value",
    coalesce(old.quantity, 0) AS "Last Months Quantity",
    coalesce(old.quantity, 0) * article.price AS "Old SEK Value"
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
    LEFT JOIN store
        ON storestock.siteid = store.storeidasinteger
    WHERE storestock.quantity > 0
        AND ABS(storestock.quantity - coalesce(old.quantity, 0)) > @significantVolumeChange
        -- optionally more conditions here
    ORDER BY storestock.quantity DESC;


-- SEK VALUE BASED
-- @significantValueChange, miniumum increase in the value of those units to be counted as a new apperence
    -- replace line 27:
            AND ABS((storestock.quantity - coalesce(old.quantity, 0)) * article.price) > @significantValueChange
    -- replace line 30:
        ORDER BY storestock.quantity * article.price DESC;

-- ONLY INCREASE (OR DECREASE)
    -- remove the ABS on line 27
    -- and reverse the > comparison and multiply significantVolumeChange by -1 for a descrease

-- ONLY NEW APPEARENCES
    -- insert after line 27
        AND coalesce(old.quantity, 0) = 0
