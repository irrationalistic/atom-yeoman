# {SelectListView} = require 'atom-space-pen-views'
{SelectListView} = require 'atom'
YeomanListView = require './yeoman-list-view'
pty = require 'pty.js'
os = require 'os'

module.exports =
class YeomanView extends SelectListView
  # @activate: -> new YeomanView
  # initialize: ->
  #   super
  #   @addClass('modal overlay from-top yeoman')
  #   @setItems(['Hello', 'World'])
  #
  #   @title = document.createElement 'h5'
  #   @title.textContent = 'Scaffolding for directory'
  #   @element.appendChild @title
  #   # atom.workspaceView.append(this)
  #   # console.log atom.workspaceView, this
  #   # @focusFilterEditor()
  #
  # toggle: ->
  #   if @hasParent()
  #     @detach()
  #   else
  #     # atom.workspaceView.append(this)
  #     # atom.workspaceView.find('atom-panel-container.modal').append this
  #     @focusFilterEditor()
  #
  # setModalTitle: (title)->
  #   @title.textContent = title





  constructor: (serializedState) ->
    myEnv = process.env
    myEnv.NODE_PATH += ':/usr/local/lib/node_modules'
    @ptyProc = pty.spawn process.env.SHELL, [], cwd: '/Users/crolfs/test', env: myEnv
    @ptyProc.on 'data', (data) ->
      ###
        If a generator is in-progress,
        this will update the list to show
        possible responses to the current
        question
      ###
      if data.indexOf('[32m?[39m') is 0
        console.log data

    @ptyProc.write "yo doctor#{os.EOL}"

    # Create root element
    @element = document.createElement('div')
    @element.classList.add('yeoman')

    # Create message element
    @title = document.createElement 'h5'
    @title.textContent = 'Scaffolding for directory'
    @element.appendChild @title

    @listView = new YeomanListView
    console.log @listView
    @element.appendChild @listView.element

    console.log 'Adding listeners'
    @listView.events.on 'cancelled', ()=>
      console.log 'cancelled list!'
      @modalPanel.hide()

    @listView.events.on 'confirmed', (item)=>
      console.log 'confirmed', item
      @ptyProc.write "yo #{item.name}#{os.EOL}"


    @modalPanel = atom.workspace.addModalPanel(item: @getElement(), visible: false)

  setModalTitle: (title)->
    @title.textContent = title

  setListItems: (items)->
    @listView.setItems items

  toggle: ()->
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
      @listView.focusFilterEditor()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()
    @ptyProc.terminate()

  getElement: ->
    @element
