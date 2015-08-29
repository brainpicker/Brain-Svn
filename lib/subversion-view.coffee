SubversionRepo = require './subversion-repo'
{BufferedProcess} = require 'atom'

module.exports =
class SubversionView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('subversion', 'inline-block')

    # Create message element
    message = document.createElement('div')
    message.textContent = "The Subversion package is Alive! It's ALIVE!"
    message.classList.add('message')
    @element.appendChild(message)

    @subversionRepo = new SubversionRepo(serializedState)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  setCount: (count) ->
    displayText = "There are #{count} words."
    @element.children[0].textContent = displayText

  getActiveItemPath: ->
    @getActiveItem()?.getPath?()

  getRepositoryForActiveItem: ->
    [rootDir] = atom.project.relativizePath(@getActiveItemPath())
    rootDirIndex = atom.project.getPaths().indexOf(rootDir)

    svnInfo = subversionRepo.getDirectorySvnInfo()
    console.log(svnInfo)

  getDirectorySvnInfo: ->
    console.log('getDirectorySvnInfo')
    command = 'svn'
    args = ['info']
    stdout = (output) -> console.log(output)
    exit = (code) -> console.log("svn info exited with #{code}")
    process = new BufferedProcess({command, args, stdout, exit})

    info: output
