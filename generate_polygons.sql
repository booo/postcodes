SELECT * INTO postcodes FROM (

SELECT
    (ST_Dump(ST_Polygonize(linestring))).geom, relations.id

FROM
    relations, relation_members, ways

WHERE

    (relations.tags @> hstore('boundary','postal_code') OR relations.tags ? 'postal_code')
AND
    relations.id = relation_members.relation_id
AND
    relation_members.member_id = ways.id
GROUP BY
    relations.id

) AS postcodes
