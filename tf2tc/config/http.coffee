##
# http.coffee -> middleware for game data and open id auth.


connect = require 'connect'
game_apps = require './game_apps.coffee'
openid_apps = require './openid_apps.coffee'
profile = false


routes = connect.router (app) ->
    app.get '/schema', game_apps.schema
    app.get /^\/profile\/(7656\d{13})/, game_apps.profile
    app.get /^\/items\/(7656\d{13})/, game_apps.items
    app.get SS.config.openid_auth.authen_path, openid_apps.authen(SS.config.openid_auth)
    app.get SS.config.openid_auth.verify_path, openid_apps.verify(SS.config.openid_auth)


exports.primary = [
    (if profile then connect.profiler else connect.responseTime)()
    routes
    connect.favicon __dirname + '/../public/favicon.ico'
]


exports.secondary = []
