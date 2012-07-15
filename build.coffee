#!/usr/bin/env coffee
fs = require 'fs'
src = fs.readFileSync("#{__dirname}/src/be.coffee").toString 'utf-8'
fs.writeFileSync "#{__dirname}/dist/be.js", require('coffee-script').compile(src, { bare: true })
