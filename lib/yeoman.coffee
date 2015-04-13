YeomanView = require './yeoman-view'
{CompositeDisposable} = require 'atom'

module.exports = Yeoman =
  yeomanView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @yeomanView = new YeomanView(state.yeomanViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @yeomanView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'yeoman:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @yeomanView.destroy()

  serialize: ->
    yeomanViewState: @yeomanView.serialize()

  toggle: ->
    console.log 'Yeoman was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
