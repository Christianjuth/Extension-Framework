###
From the ExtJS team
-------------------
The code below was designed by the ExtJS team to providing useful info to the
developers. We ask you do not change this code unless necessary. By keeping
this standard on all plugins, we hope to make development easy by providing
useful info to developers.  In addition to logging, the code below also
contains the AMD function for defining the plugin.  This waits for the ExtJS
AMD module to define the library itself, and then your plugin is defined
which prevents any undefined errors.  Although not suggested, plugins can be
loaded before the ExtJS library.  The functionality below assures ease of
use.

https://github.com/Christianjuth/ExtJS_Library/tree/plugin
###

#set vars
BROWSER = ''
NAME = PLUGIN._.name
ID = NAME.toLowerCase().replace(/\ /g,"_")
if PLUGIN._.options
  PLGDEFAULTOPTIONS = PLUGIN._.options
PLGOPTIONS = ->
  if PLUGIN._.defaultOptions
    output = $.extend(PLGDEFAULTOPTIONS, PLUGIN._.options)
  else
    throw Error 'Plugin does not have options'
  return optput
PLUGIN.configure = (opts)->
  PLUGIN._.options = $.extend(PLGDEFAULTOPTIONS,opts)
#console logging
log = {
  error: (msg)-> do->
    msg = 'Ext plugin ('+NAME+') says: '+msg
    ext._.log.error msg

  warn: (msg)-> do->
    msg = 'Ext plugin ('+NAME+') says: '+msg
    ext._.log.warn msg

  info: (msg)-> do->
    msg = 'Ext plugin ('+NAME+') says: '+msg
    ext._.log.info msg
  }
#set background var
if PLUGIN._.background is true
  BACKGROUND = do ->
    if ext._.browser is 'chrome'
      bk = chrome.extension.getBackgroundPage().window
    if ext._.browser is 'safari'
      bk = safari.extension.globalPage.contentWindow
    return bk
#setup AMD support if browser supports the AMD define function
if typeof window.define is 'function' && window.define.amd
  window.define ['ext'], (ext)->
    BROWSER = ext._.browser
    #load ExtJS meets VERSION requirements
    if !PLUGIN._.minLib? or PLUGIN._.minLib <= window.ext._.version
      ext._.load(ID,PLUGIN)
    else
      VERSION = PLUGIN._.min
      log.error 'Ext plugin ('+NAME+') requires ExtJS v'+VERSION+'+'