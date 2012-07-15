###
Be.js
###
class BeJS
  # Static class properties
  this.injection_rx = new RegExp '([\'"<>\\$`\\[\\]()\\\\\\;%\\+])', 'g'
  this.version = '0.1.0'  
  this.quiet = true
  
  # Constructor
  constructor: (doMonkeyPatch=false, verbose=false) ->
    @monkeyPatch(clazz) for clazz in [String, Number] if doMonkeyPatch
    @environment = 'browser'
    BeJS.quiet = !verbose

    # Am I running on Node.js or browser???
    @environment = if process? and process.title is 'node' then 'node' else 'browser'
  
  verbose: ->
    BeJS.quiet = false
    
  quiet: ->
    BeJS.quiet = true

  ###
  Number functions
  ###
  shownAsTime: (value) ->
    return 0 if value is null
    return [Number] if value is 'BeJS_monkey_patch'
    return '00:00:00' if value is 0 or (typeof(value) is not 'number')
    s = Math.floor (value / 1000) % 60
    m = Math.floor ((value / 1000) / 60) % 60
    h = Math.floor ((value / 1000) / 60) / 60

    "#{if h > 9 then '' else '0'}#{h}:#{if m > 9 then '' else '0'}#{m}:#{if s > 9 then '' else '0'}#{s}"    
    
  ###
  String functions
  ###
  sanitized: (value) ->
    return '' if value is null
    value.toString().replace this.injection_rx, ''
    
  safe: (value) ->
    return '' if value is null
    value.toString().replace this.injection_rx, "\\$1"
    
  stripped: (value) ->
    return '' if value is null
    value.toString().replace /(^ +| +$)/g, ''
    
  slugified: (value) ->
    return '' if value is null
    this.stripped(value.toString().toLowerCase()).replace(/\W+/g, '_').replace(/_+$/g, '')
    
  capitalized: (value) ->
    return '' if value is null
    value.toString().toLowerCase().replace(/(\b[a-z])/g, '_BeJS_CAP_$1').split(/_BeJS_CAP_/).map((w) -> (w[0] or '').toUpperCase() + w.substring 1).join('')

  sentence: (array...) ->
    if this._isArray.apply(this, array)
      array = array[0]
    return array[0] if array.length == 1
    comma_joined = this._withoutLast.apply(this, array).join(', ')
    last = this._last.apply(this, array)
    [comma_joined, last].join(' and ')
  ###
  Monkey Patcher
  Expands String and Number classes by embedding functions into their prototypes
  ###

  monkeyPatched: (clazz) ->
    return null if clazz is null
    throw new Error('can only patch String and Number') if ['String', 'Number'].indexOf(clazz.name) is -1
    for k, v of be
      if typeof(v) is 'function' and clazz.name.toLowerCase() is typeof(v(null))
        console.log(">>> patching '", k, "' function into", clazz.name, "class") unless BeJS.quiet
        eval clazz.name + ".prototype['#{k}'] = function () { return be['#{k}'](this) };"
    if @be_quiet then undefined else clazz.name + ' patched!'
    
   ###
   Internals
   ###
   _withoutLast: (passed_array...) ->
     passed_array.slice(0, passed_array.length - 1)
     
   _last: (passed_array...) ->
     passed_array.slice(-1)
     
   _isArray: (obj)->
     obj.constructor == '[Function: Array]' || toString.call(obj) == '[object Array]'

# Let me BeJS
be = new BeJS()

if be.environment is 'node'
  module.exports = be
else
  window.be = be
