plugin = {

  _info :
    authors : ['Christian Juth']
    name : 'UUID'
    version : '0.1.0'
    compatibility :
      chrome : 'full'
      safari : 'full'

  _aliases : ['UUID']

  _load : (options) ->
    if !localStorage.uuid?
      s = []
      hexDigits = '0123456789abcdef'
      i=0
      while i <= 36
        i++
        s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1)
      s[14] = '4'
      s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1)
      s[9] = s[14] = s[19] = s[23] = '-'
      uuid = s.join('');
      #log reset
      if options.silent isnt true
        console.info('UUID "' + uuid + '" was created')
      localStorage.uuid = uuid

  #functions
  reset : ->
    options = window.ext._config
    s = []
    hexDigits = '0123456789abcdef'
    i=0
    while i <= 36
      i++
      s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1)
    s[14] = '4'
    s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1)
    s[9] = s[14] = s[19] = s[23] = '-'
    uuid = s.join('');
    #log reset
    if options.silent isnt true
      console.info('UUID was reset to "' + uuid + '"')
    localStorage.uuid = uuid

  get : ->
    return localStorage.uuid

}

#setup AMD support
if typeof window.define is 'function' && window.define.amd
  window.define ['ext'], ->
    #vars
    name = plugin._info.name
    id = ext.parse.id(name)
    #load plugin if valid
    if !plugin._info.min? or plugin._info.min <= window.ext.version
      window.ext[id] = plugin
    else
      console.error 'Ext plugin (' + name + ') required a minimum of ExtJS v' + plugin._info.min