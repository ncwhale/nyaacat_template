util = require 'util'

log = (msg...) ->
  util.log "#{util.format msg}"

debug = (msg...) ->
        util.debug "#{util.format msg}"

error = (msg...) ->
        util.error "#{util.format msg}"
    
module.exports = log
module.exports.debug = debug
module.exports.error = error
