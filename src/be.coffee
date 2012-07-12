###
Be.js
###
class BeJS
  ###
  Internal stuff
  ###
  injection_rx: new RegExp '([\'"<>\\$`\\[\\]()\\\\\\;%\\+])', 'g'
  
  environment: 'browser'
  
  _quiet: true
  
  verbose: ->
    this._quiet = false
    
  quiet: ->
    this._quiet = true

  ###
  Number functions
  ###
  time: (value) ->
    return 0 if value is null
    return [Number] if value is 'BeJS_monkey_patch'
    return '00:00:00' if value is 0 or (typeof(value) is not 'number')
    s = Math.floor (value / 1000) % 60
    m = Math.floor ((value / 1000) / 60) % 60
    h = Math.floor ((value / 1000) / 60) / 60
    return "#{if h > 9 then '' else '0'}#{h}:#{if m > 9 then '' else '0'}#{m}:#{if s > 9 then '' else '0'}#{s}"    
    
  ###
  String functions
  ###
  paranoid_safe: (value) ->
    return '' if value is null
    value.toString().replace this.injection_rx, ''
    
  safe: (value) ->
    return '' if value is null
    value.toString().replace this.injection_rx, "\\$1"
    
  slug: (value) ->
    return '' if value is null
    value.toString().toLowerCase().replace(/\W+/g, '_').replace /[^\W]$/, ''
    
  strip: (value) ->
    return '' if value is null
    value.toString().replace /(^ +| +$)/g, ''
    
  capitalized: (value) ->
    return '' if value is null
    value.toString().replace(/(\b[a-z])/g, '_BeJS_CAP_$1').split(/_BeJS_CAP_/).map((w) -> (w[0] or '').toUpperCase() + w.substring 1).join('')

  ###
  Monkey Patcher
  Expands String and Number classes by embedding functions into their prototypes
  ###
  monkey_patch: (clazz) ->
    return null if clazz is null
    throw new Error('can only patch String and Number') if ['String', 'Number'].indexOf(clazz.name) is -1
    for k, v of be
      if typeof(v) is 'function' and clazz.name.toLowerCase() is typeof(v(null))
        console.log(">>> patching '", k, "' function into", clazz.name, "class") unless this._quiet
        eval clazz.name + ".prototype['#{k}'] = function () { return be['#{k}'](this) };"
    if this._quiet then undefined else clazz.name + ' patched!'

# Let me BeJS
be = new BeJS

# Am I running on Node.js or browser???
if process? and process.title is 'node'
  BeJS.environment = 'node'
  module.exports = be
else
  window.be = be
