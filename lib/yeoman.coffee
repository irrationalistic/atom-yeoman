YeomanView = require './yeoman-view'
{CompositeDisposable} = require 'atom'
childProcess = require 'child_process'
fs = require 'fs'
pty = require 'pty.js'
os = require 'os'
path = require 'path'

# {allowUnsafeEval, allowUnsafeNewFunction} = require 'loophole'
#
# yeoman = require 'yeoman-environment'
# allowUnsafeEval -> allowUnsafeNewFunction ->
#   env = yeoman.createEnv()
#   console.log env
# yeoman = require('../node_modules/yeoman-environment/lib/resolver')
# env = yeoman.createEnv()

###
  Helpful stuff:
    - https://github.com/magbicaleman/open-in-browser/blob/master/lib/open-in-browser.coffee
    - https://github.com/guileen/terminal-status/blob/master/lib/command-output-view.coffee
    - https://github.com/jamischarles/atom-todo-show/blob/master/lib/show-todo-view.coffee#L15 (allow unsafe execution)
###

module.exports = Yeoman =
  yeomanView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @yeomanView = new YeomanView()

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

  getSelectedPath: ()->
    packageObj = null
    if atom.packages.isPackageLoaded('tree-view') == true
      treeView = atom.packages.getLoadedPackage('tree-view')
      treeView = require(treeView.mainModulePath)
      packageObj = treeView.serialize()
    if typeof packageObj != 'undefined' && packageObj != null
      return packageObj.selectedPath
    return null

  getGenerators: (cb)->
    modulesDir = '/usr/local/lib/node_modules'
    fs.readdir modulesDir, (err, files)=>
      console.log err, files
      processed = files
        .filter (i)-> /generator-(.*)/.test i
        .map (i)->
          results = /generator-(.*)/.exec i
          file: i, name: results[1]
      console.log processed
      @yeomanView.setListItems processed

      # proc = childProcess.spawn '/usr/local/bin/yo',['refactoru-html'], cwd: '~/test'
      # proc.stdout.on 'data', (data)-> console.log 'stdout:', data
      # proc.stderr.on 'data', (data)-> console.log 'stderr:', data
      # proc.on 'close', (data)-> console.log 'close:', data


      # testing pty
      # @ptyProc = pty.spawn process.env.SHELL, [], cwd: '/Users/crolfs/test', env: process.env
      # @ptyProc.on 'data', (data) -> console.log data
      # setTimeout ()=>
      #   # @ptyProc.write "cd ~/test#{os.EOL}"
      #   @ptyProc.write "pwd#{os.EOL}"
      # , 500

      ###
      ls.stdout.on('data', function (data) {
  console.log('stdout: ' + data);
});

ls.stderr.on('data', function (data) {
  console.log('stderr: ' + data);
});

ls.on('close', function (code) {
  console.log('child process exited with code ' + code);
});
###
    # find the path plz:
    # childProcess.exec 'ls /usr/local/lib/node_modules', (err, stdout, stderr)->
    #   console.log arguments

  toggle: ->
    console.log 'Yeoman was toggled!'

    # @yeomanView.toggle()

    @yeomanView.toggle()

    @getGenerators()

    # tests:
    # console.log yeoman
    # could get the current project's path
    # by finding which is selected and
    # then using that to feed the resolver?

    tPath = @getSelectedPath()
    fs.stat tPath, (e, stats)=>
      tPath = path.dirname tPath if !stats.isDirectory()
      @yeomanView.setModalTitle tPath
    # if path
      # now do that resolver stuff...

    # @openPath packageObj.selectedPath
    # console.log packageObj.selectedPath




    ###

      What do?

      - Need to figure out how to get access to yeoman generator list
      - Need to understand how to actually execute yeoman generators

    ###


    # if @modalPanel.isVisible()
    #   @modalPanel.hide()
    # else
    #   @modalPanel.show()
