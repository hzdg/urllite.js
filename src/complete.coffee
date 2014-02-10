# Load the core, then every extension.

urllite = require './core'
require './extensions/resolve'
module.exports = urllite
