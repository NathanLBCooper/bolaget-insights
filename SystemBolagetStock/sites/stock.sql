select
    CONCAT(store.name, ' ', store.address1, ' ', store.address2) AS "Store",
    storestock.siteId,
    CONCAT(article.name, ' ', article.name2) AS "Article Full Name",
    article.articleid,
    store.wgs84coordinates[0] as "longitude",
    store.wgs84coordinates[1] as "latitude",
    storestock.quantity,
    storestock.quantity * article.price AS "SEK Value"
from store
inner join storestock on store.storeidasinteger = storestock.siteid
inner join article on storestock.articleid = article.articleid
-- conditions
