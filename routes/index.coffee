exports.index = (req, res) ->
  res.render "index",
    id: req.params.id
