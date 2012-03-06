UPDATE postcodes SET postal_code = foo.postal_code FROM

(SELECT tags->'postal_code' as postal_code, relations.id FROM postcodes, relations WHERE postcodes.id = relations.id) AS foo

WHERE postcodes.id = foo.id

