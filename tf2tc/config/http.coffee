

connect = require 'connect'
game_urls = require './game_urls.coffee'
openid_urls = require './openid_urls.coffee'


exports.primary = [
    connect.router (app) ->
        app.get '/schema', game_urls.schema
        app.get /^\/profile\/(7656\d{13})/, game_urls.profile
        app.get /^\/items\/(7656\d{13})/, game_urls.items
        app.get SS.config.openid_auth.authen_path, openid_urls.authen(SS.config.openid_auth)
        app.get SS.config.openid_auth.verify_path, openid_urls.verify(SS.config.openid_auth)
]


exports.secondary = []
