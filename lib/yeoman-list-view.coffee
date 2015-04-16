{SelectListView} = require 'atom-space-pen-views'
# {SelectListView} = require 'atom'
events = require 'events'
pty = require 'pty.js'

module.exports =
class YeomanListView extends SelectListView
  initialize: ->
    super
    @events = new events.EventEmitter
    @addClass('yeoman-list')
    # @setItems(['Hello', 'World'])

  # toggle: ->
  #   if @hasParent()
  #     @detach()
  #   else
  #     # atom.workspaceView.append(this)
  #     # atom.workspaceView.find('atom-panel-container.modal').append this
  #     # atom.workspace.addModalPanel(item: @element, visible: true)
  #     @focusFilterEditor()

  getFilterKey: ->
    'name'

  viewForItem: (item) ->
    "<li>#{item.name}</li>"

  confirmed: (item) ->
    # console.log("#{item.name} was selected")
    @events.emit 'confirmed', item


  cancelled: ()->
    console.log 'cancelled!'
    @events.emit 'cancelled'
    false
