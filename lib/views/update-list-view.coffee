{Disposable} = require 'atom'
{BufferedProcess} = require 'atom'
{$, $$$, ScrollView} = require 'atom-space-pen-views'
svn = require '../svn'
which = require '../which'

module.exports =
class UpdateListView extends ScrollView
  @content: ->
    @div class: 'atom-svn-log native-key-bindings', tabindex: -1, =>
      @table id: 'atom-svn-update-log', outlet: 'updatesListView'

  onDidChangeTitle: -> new Disposable
  onDidChangeModified: -> new Disposable

  getURI: -> 'atom://atom-svn:update-log'

  getTitle: -> 'atom-svn: Update Log'

  initialize: ->
    super
    @scroll =>
      @getLog() if @scrollTop() + @height() is @prop('scrollHeight')

  parseData: (data) ->
    if data.length > 0
      separator = '   '
      newline = '_.;._'
      @updatesListView.append(data)
      console.log(data)
      # data = data.substring(0, data.length - newline.length - 1)

      # filesUpdated = data.split(newline).map (line) ->
      #   if line.trim() isnt ''
      #     tmpData = line.trim().split(separator)
      #     return {
      #       hashShort: tmpData[0]
      #       hash: tmpData[1]
      #       author: tmpData[2]
      #       email: tmpData[3]
      #       message: tmpData[4]
      #       date: tmpData[5]
      #     }
      #
      # @renderLog filesUpdated

  renderHeader: ->
    headerRow = $$$ ->
      @tr class: 'update-log-header', =>
        @td 'Status'
        @td 'File'

    @updatesListView.append(headerRow)

  renderLog: (filesUpdated) ->
    filesUpdated.forEach (fileUpdated) => @renderFileUpdated fileUpdated

  renderFileUpdated: (fileUpdated) ->
    fileUpdateRow = $$$ ->
      @tr class: 'file-updated-row', =>
        @td class: 'status', "#{fileUpdated.status}"
        @td class: 'fileName', "#{fileUpdated.fileName}"

    @updatesListView.append(commitRow)

  updateLog: (@path) ->
    @updatesListView.empty()
    @renderHeader()
    @update()

  whichSvnLog: (@path) ->
    @updatesListView.empty()
    @renderHeader()
    @whichSvn()

  svnVersionLog: (@path) ->
    @updatesListView.empty()
    @renderHeader()
    @svnVersion()

  svnInfoLog: (@path) ->
    @updatesListView.empty()
    @renderHeader()
    @svnInfo()

  update: () ->
    svn.cmd(['update'], cwd: @path)
    .then (data) => @parseData data

  info: () ->
    svn.cmd(['info'], cwd: @path)
    .then (data) => @parseData data

  whichSvn: () ->
    which.cmd(['svn'], cwd: @path)
    .then (data) => @parseData data

  svnVersion: () ->
    svn.cmd(['--version'], cwd: @path)
    .then (data) => @parseData data
