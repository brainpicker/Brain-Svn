svn = require '../svn'
UpdateListView = require '../views/update-list-view'
UpdateViewURI = 'atom://atom-svn:update-log'
{$, View} = require 'atom-space-pen-views'

module.exports = (e) ->
  path = $(e.target).closest(".project-root > .header").find(".name").data("path")
  atom.workspace.addOpener (uri) ->
    return new UpdateListView if uri is UpdateViewURI

  atom.workspace.open(UpdateViewURI).then (view) ->
    view.whichSvnLog path
