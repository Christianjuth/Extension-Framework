###!
The MIT License (MIT)

Copyright (c) 2014 Christian Juth

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
###

PLUGIN = {

_: {

#INFO
authors : ['Christian Juth']
name : 'Popup'
version : '0.1.0'
libMin : '0.1.0'
background:  false
compatibility :
  chrome : 'full'
  safari : 'full'

}



#FUNCTIONS
setWidth: (width)->
  #check usage
  usage = 'width number'
  expected = ['number']
  ok = ext._.validateArg(arguments,expected,usage)
  throw new Error(ok) if ok?
  validateLocation()
  if BROWSER is 'chrome'
    $('html, body').width(width)
  if BROWSER is 'safari'
    safari.self.width = width



setHeight: (height)->
  #check usage
  usage = 'height number'
  expected = ['number']
  ok = ext._.validateArg(arguments,expected,usage)
  throw new Error(ok) if ok?
  validateLocation()
  if BROWSER is 'chrome'
    $('html, body').height(height)
  if BROWSER is 'safari'
    safari.self.height = height



codeWrap: (callback)->
  #check usage
  usage = 'callback function'
  expected = ['function']
  ok = ext._.validateArg(arguments,expected,usage)
  throw new Error(ok) if ok?
  validateLocation()
  #logic
  if BROWSER is 'chrome'
    callback()
  if BROWSER is 'safari'
    safari.application.addEventListener("popover", callback, true)


}



validateLocation = ->
  #vars
  valid = false
  #validate
  if BROWSER is 'safari'
    details = safari.extension
    if details.popovers[0]?
      popup = safari.extension.popovers[0].contentWindow
      valid = window is popup.window
  if BROWSER is 'chrome'
    details = chrome.app.getDetails()
    if details.browser_action?
      popup = chrome.app.getDetails().browser_action.default_popup
      valid = ext.match.url(location.pathname,'{/,}'+popup)
  if !valid
    throw Error 'ext.popup.codeWrap() must be run from a popup'

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