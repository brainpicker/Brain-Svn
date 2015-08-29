{BufferedProcess} = require 'atom'

module.exports =
class SubversionRepo
  constructor: (serializedState) ->

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  getDirectorySvnInfo: ->
      command = 'svn info'
      stdout = (output) -> console.log(output)
      exit = (code) -> console.log("svn info exited with #{code}")
      process = new BufferedProcess({command, args, stdout, exit})
