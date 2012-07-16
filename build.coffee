#!/usr/bin/env coffee
#
# ALWAYS run this before testing and commiting
#
fs = require 'fs'
coffee = require('coffee-script')
src = coffee.compile fs.readFileSync("#{__dirname}/src/be.coffee").toString('utf-8'), { bare: true }
fs.writeFileSync "#{__dirname}/dist/be.js", src

# Be.ugly
jsp = require("uglify-js").parser
pro = require("uglify-js").uglify
src = pro.gen_code(pro.ast_squeeze(pro.ast_mangle(jsp.parse(src))))
fs.writeFileSync "#{__dirname}/dist/be.min.js", src
