url = require 'url'


exports.call = (request, response) ->
    u = url.parse request.url
    p = u.pathname
    if p.match(/\.(png|gif|jpg)$/)
        response.removeHeader 'Etag'
        response.removeHeader 'Cache-Control'
        response.setHeader 'Last-Modified', expiry(0)
        response.setHeader 'Date', expiry(0)
        response.setHeader 'Expires', expiry(24*7)


expiry = (hours=24*7) ->
    d = new Date()
    d.setHours(d.getHours() + hours)
    d
