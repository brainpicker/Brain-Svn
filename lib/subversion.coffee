SubversionView = require './subversion-view'
{CompositeDisposable} = require 'atom'

module.exports = Subversion =
  subversionView: null
  modalPanel: null
  subscriptions: null
  state: null

  activate: (state) ->
    @state = state

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    console.log 'Subversion was toggled!'

    @subscriptions.add atom.commands.add 'atom-workspace', 'subversion:info': => @svnInfo()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @subversionView.destroy()

  serialize: ->
    subversionViewState: @subversionView.serialize()

  consumeStatusBar: (statusBar) ->
    @statusBar = statusBar
    @subversionView = new SubversionView(@state.subversionViewState)
    # @modalPanel = atom.workspace.addModalPanel(item: @subversionView.getElement(), visible: false)
    @statusBarTile = statusBar.addRightTile(item: @subversionView.getElement(), priority: 100)

  svnInfo: ->
    console.log('svn Info')
    info = @subversionView.getDirectorySvnInfo()
    console.log(info.toString())
