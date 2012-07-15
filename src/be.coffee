###
Be.js
###
class BeJS
  ###
  Internals and Static class properties
  ###
  this.injectionRegExp = new RegExp '([\'"<>\\$`\\[\\]()\\\\\\;%\\+])', 'g'

  this.version = '0.1.0'  

  this.quiet = true
    
  this._withoutLast = (passed_array...) ->
    passed_array.slice(0, passed_array.length - 1)
   
  this._last = (passed_array...) ->
    passed_array.slice(-1)
     
  this._isArray = (obj)->
    toString.call(obj) == '[object Array]'

  this._isFunction = (obj)->
    toString.call(obj) == '[object Function]'

  this._isDate = (obj)->
    toString.call(obj) == '[object Date]'

  
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
    zeroTime = '00:00:00'
    return zeroTime if value is 0 or (typeof(value) is not 'number')
    s = Math.floor (value / 1000) % 60
    m = Math.floor ((value / 1000) / 60) % 60
    h = Math.floor ((value / 1000) / 60) / 60
    return zeroTime if isNaN(s) or isNaN(m) or isNaN(h)
    "#{if h > 9 then '' else '0'}#{h}:#{if m > 9 then '' else '0'}#{m}:#{if s > 9 then '' else '0'}#{s}"    
    
  ###
  String functions
  ###
  sanitized: (value) ->
    return '' if value is null
    value.toString().replace BeJS.injectionRegExp, ''
    
  safe: (value) ->
    return '' if value is null
    value.toString().replace BeJS.injectionRegExp, "\\$1"
    
  stripped: (value) ->
    return '' if value is null
    value.toString().replace /(^ +| +$)/g, ''
    
  slugified: (value) ->
    return '' if value is null
    this.stripped(value.toString().toLowerCase()).replace(/\W+/g, '_').replace(/_+$/g, '')
    
  capitalized: (value) ->
    return '' if value is null
    ###
    WARNING: Performance v.s. Aesthetic choice follows
    Some might agree this code is uggly as hell, but I bet you sweat a lot trying to code a faster one...  ;)
    Next best code I came up with runs 1.8 times slower... :S
    ###
    value.toString().toLowerCase().replace(/(\b[a-z])/g, '_BeJS_CAP_$1').split(/_BeJS_CAP_/).map((w) -> (w[0] or '').toUpperCase() + w.substring 1).join('')

  sentence: (array...) ->
    array = array[0] if BeJS._isArray.apply(this, array)
    return array[0] if array.length == 1
    [BeJS._withoutLast.apply(this, array).join(', '), BeJS._last.apply(this, array)].join(' and ')
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

# Let me BeJS
be = new BeJS()

if be.environment is 'node'
  module.exports = be
else
  window.be = be
