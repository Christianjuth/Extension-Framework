PLUGIN = {



_: {

#INFO
authors : ['Christian Juth']
name : 'Tabs'
version : '0.1.0'
libMin : '0.1.0'
background:  false
compatibility :
  chrome : 'full'
  safari : 'full'

#EVENTS
onload: ->
  if BROWSER is 'safari'
    #define ins on launch
    id = 0
    tabs = []
    for TabWindow in safari.application.browserWindows
      tabs = tabs.concat TabWindow.tabs
      for tab in tabs
        tab.id = id++ if !tab.id?
      tabs = tabs
    #defind id on new tab
    ext.tabs.onCreate (tab) ->
      tabs = []
      for TabWindow in safari.application.browserWindows
        tabs = tabs.concat TabWindow.tabs
        for tab in tabs
          tab.id = id++ if !tab.id?
        tabs = tabs

}



#get a specific tab by its id
get: (id, callback)->
  if BROWSER is 'chrome'
    chrome.tabs.get id, (tab)->
      if tab?
        callback(new Tab(tab)) if callback?
  if BROWSER is 'safari'
    ext.tabs.all (tabs)->
      for t in tabs
        callback(new Tab(t)) if t.id is id and callback?



#This function allows you to
#creat a new tab
create: (url, callback)->
  defultOptions = {
    url:    '**'
    pinned: false
    active: false
  }
  if typeof url isnt "object"
    url = {url:ext.parse.url(url)}
  else
    url.url = ext.parse.url(url.url)
  options = $.extend defultOptions, url
  if BROWSER is 'chrome'
    chrome.tabs.create {
      url: options.url,
      pinned: options.pinned,
      active: options.active
    }
    callback() if callback?
  else if BROWSER is 'safari'
    safari.application.activeBrowserWindow.openTab().url = options.url
    callback() if callback?



#This function duplicates a
#tab based on its id
duplicate: (id, callback)->
  ext.tabs.get id, (tab)->
    ext.tabs.create tab, callback



#This function lets you query all
#they open tabs using extjs's url
#matching function
query: (urlSearch, callback)->
  if !callback?
    throw Error 'Function requires a callback'
  defultOptions = {
    url: '**'
#   pinned:''
  }
  if typeof urlSearch isnt "object"
    urlSearch = {url:urlSearch}
  options = $.extend defultOptions, urlSearch
  #chrome query options
  chromeQuery = {windowType:"normal"}
  if options.pinned?
    chromeQuery.pinned = options.pinned
  #vars
  tabs = []
  outputTabs = []

  if BROWSER is 'chrome'
    chrome.tabs.query chromeQuery, (tabs) ->
      for tab in tabs
        #strip trailing "/" from url
        url = tab.url.replace /(\/)$/,''
        #check if url matches options.url
        if ext.match.url(url, options.url) isnt false
          outputTabs.push(new Tab(tab))
          outputTabs.sort(compare)
      callback(outputTabs)

  else if BROWSER is 'safari'
    for TabWindow in safari.application.browserWindows
      tabs = tabs.concat TabWindow.tabs
    for tab in tabs
      url = tabs.url
      #prevent undefined error
      if !url?
        url = ''
      #strip trailing "/" from url
      url = url.replace /(\/)$/,''
      #check if url matches options.url
      if ext.match.url(url, options.url) isnt false
        outputTabs.push(new Tab(tab))
        outputTabs.sort(compare)
    callback(outputTabs)

  return options.url



#This function returns all
#tabs in a callback function
all: (callback)->
  if !callback?
    throw Error 'Function requires a callback'
  ext.tabs.query '**', (tabs) ->
    callback(tabs)



#This function returns the active
#tab in a callback functioin
active: (callback)->
  if !callback?
    throw Error 'Function requires a callback'
  if BROWSER is 'chrome'
    chrome.tabs.query {active:true}, (tab) ->
      callback(new Tab(tab[0]))
  if BROWSER is 'safari'
    tab = safari.application.activeBrowserWindow.activeTab
    callback(new Tab(tab))



#This function returns the oldest
#tab in a callback function
oldest: (callback, search)->
  if !callback?
    throw Error 'Function requires a callback'
  defaultSearch = {
    url: '**'
  }
  search = $.extend defaultSearch, search
  tabs = ext.tabs.query search, (tabs) ->
    oldest = 9007199254740992
    for tab in tabs
      if tab.id < oldest
        oldest = tab.id
    for tab in tabs
      if tab.id is oldest
        callback(tab)



#This function returns the newest
#tab in a callback function
newest: (callback, search)->
  if !callback?
    throw Error 'Function requires a callback'
  defaultSearch = {
    url: '**'
  }
  search = $.extend defaultSearch, search
  tabs = ext.tabs.query search, (tabs) ->
    oldest = -1
    for tab in tabs
      if tab.id > oldest
        oldest = tab.id
    for tab in tabs
      if tab.id is oldest
        callback(tab)



go: (id,url)->
  ext.tabs.get id, (tab)->
    tab.go(url);



#Events

#This function defines a callback
#which is triggered when any new
#tab is opened
onCreate: (callback)->
  if !callback?
    throw Error 'Function requires a callback'
  if BROWSER is 'chrome'
    chrome.tabs.onCreated.addListener (tab) ->
      callback(new Tab(tab))
  if BROWSER is 'safari'
    safari.application.addEventListener 'open', (e) ->
      tab = e.target
      callback(new Tab(tab))
    , true




#This function defines a callback
#which is triggered when any tab
#id closed
onDestroy: (callback)->
  if !callback?
    throw Error 'Function requires a callback'
  if BROWSER is 'chrome'
    chrome.tabs.onRemoved.addListener (tab)->
      callback(new Tab(tab))
  if BROWSER is 'safari'
    safari.application.addEventListener 'close', (e) ->
      tab = e.target
      callback(new Tab(tab))
    , true
}



#LOCAL CODE

#Tab sort function
compare = (a,b) ->
  if a.id < b.id
    return -1
  if a.id > b.id
    return 1
  return 0



#Parse tab function
Tab = (tab) ->
  #vars
  this.url = tab.url
  this.title = tab.title
  this.id = tab.id
  this.pinned = tab.pinned
  close = -> do (tab) ->
    tab.close()
  #destroy function
  this.duplicate = ->
    ext.tabs.duplicate this.id
  this.destroy = (force) ->
    if BROWSER is 'chrome'
      chrome.tabs.remove this.id
    if BROWSER is 'safari'
      close()
  #Callback triggerd when tab is active
  this.onActive = (callback) ->
    id = this.id
    if BROWSER is 'chrome'
      chrome.tabs.onActivated.addListener (e)->
        if e.tabId is id
          ext.tabs.get(e.tabId, callback)

    if BROWSER is 'safari'
      safari.application.addEventListener 'activate', (e) ->
        tab = e.target
        if tab.id is id
          callback(new Tab(tab))
      , true
  this.go = (url)->
    url = ext.parse.url(url)
    if BROWSER is 'chrome'
      chrome.tabs.update(this.id,{url:url})
    if BROWSER is 'safari'
      tab.url = url
    this.url = tab.url


  #return
  return this