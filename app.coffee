#!/usr/bin/env coffee

CONNECTION_STRING = (require "./config").CONNECTION_STRING

express = require "express"
pg = require "pg"

routes = require "./routes"
postcodes = require "./routes/postcodes"

app = module.exports = express.createServer()

app.configure ->
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static __dirname + "/public"
  app.enable "jsonp callback"

app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure "production", ->
  app.use express.errorHandler()


# routes

app.get "/", routes.index

app.get "/:id", routes.index


loadPgClient = (req, res, next) ->
  pg.connect CONNECTION_STRING, (error, client) ->
    if error then next error
    else
      req.client = client
      next()


app.get "/api/postcodes", loadPgClient, postcodes.index
app.get "/api/postcodes/:id", loadPgClient, postcodes.id

app.listen 3000
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
