util = require 'util'


exports.log = util.log


exports.getId64 = (s) ->
    if s.user_id then s.user_id.split('/').pop() else undefined
