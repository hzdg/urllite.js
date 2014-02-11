# Load the core, then every extension.

urllite = require './core'
require './extensions/resolve'
require './extensions/relativize'
module.exports = urllite
