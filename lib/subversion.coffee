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

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace',
      'subversion:toggle': => @toggle()

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

  toggle: ->
    console.log 'Subversion was toggled!'

    # if @modalPanel.isVisible()
      # @modalPanel.hide()
    # else
    editor = atom.workspace.getActiveTextEditor()
    words = editor.getText().split(/\s+/).length
    @subversionView?.setCount(words)
      # @modalPanel.show()
