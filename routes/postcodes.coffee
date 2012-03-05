exports.index = (req, res) ->
  res.render "index",
    title: "Express"

exports.id = (req, res, next) ->
  statement =
    text: "SELECT
            ST_AsGeoJSON(postcodes.geom) AS geom, postcodes.id
          FROM
            postcodes
          WHERE
            postcodes.id = $1"
    values: [req.params.id]

  query = req.client.query statement, (error, result) ->
    if error then next error
    else
      res.send
        type: "FeatureCollection"
        features: [
          {
            type: "Feature"
            geometry: JSON.parse result.rows[0].geom
            id: result.rows[0].id
          }

        ]

#TODO Implement streaming

exports.index = (req, res, next) ->

  bbox = JSON.parse req.query.bbox

  statement =
    text: "SELECT
            ST_AsGeoJSON(postcodes.geom) AS geom, postcodes.id
          FROM
            postcodes
          WHERE
            ST_Intersects(postcodes.geom, ST_SetSRID(ST_MakeBox2D(ST_Point($1,$2), ST_Point($3,$4)), 4326));
          "
    values: bbox

  query = req.client.query statement, (error, result) ->
    if error then next error
    else
      featureCollection =
        type: "FeatureCollection"
        features: []

      for row in result.rows
        featureCollection.features.push {
          type: "Feature"
          geometry: JSON.parse row.geom
          id: row.id
        }

      res.send featureCollection

