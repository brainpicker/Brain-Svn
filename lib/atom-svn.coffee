BrainSvnView = require './atom-svn-view'
{CompositeDisposable} = require 'atom'
SvnUpdate = require './models/svn-update'
WhichSvn = require './models/which-svn'
SvnVersion = require './models/svn-version'

module.exports = BrainSvn =
  config:
    svnPath:
      type: 'string'
      default: 'svn'
      description: 'Where is your svn?'

  brainSvnView: null
  modalPanel: null
  subscriptions: null
  state: null

  activate: (state) ->
    @state = state

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-svn:info': ({target}) => @svnInfo()
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-svn:commit': ({target}) => @svnInfo()
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-svn:update': (e) => SvnUpdate(e)
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-svn:revert': ({target}) => @svnInfo()
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-svn:switch': ({target}) => @svnInfo()
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-svn:info': (e) => SvnInfo(e)
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-svn:which': (e) => WhichSvn(e)
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-svn:svn-version': (e) => SvnVersion(e)

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @brainSvnView.destroy()

  serialize: ->
    brainSvnViewState: @brainSvnView.serialize()

  consumeStatusBar: (statusBar) ->
    @statusBar = statusBar
    @brainSvnView = new BrainSvnView(@state.brainSvnViewState)

    @statusBarTile = statusBar.addRightTile(item: @brainSvnView.getElement(), priority: 100)
