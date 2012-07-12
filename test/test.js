var should = require('should'),
    be = require('../dist/be');

describe("Be", function(){
  describe("stripped",function(){
    it('should remove leading and trailing whitespace', function(){
      be.stripped(' test_string ').should.equal('test_string')
    })
    it('should not remove whitespace in the middle', function(){
      be.stripped('test is string').should.equal('test is string')
    })
  })
  describe("slugified",function(){
    it('should remove leading and trailing whitespace', function(){
      be.slugified(' tests string ').should.equal('tests_string')
    })
    it('should replace whitespace in the middle with underscore', function(){
      be.slugified('test is string').should.equal('test_is_string')
    })
    it('should only leave underscore and a-z', function(){
      be.slugified('test, is string!!!').should.equal('test_is_string')
    })
    it('should downcase', function(){
      be.slugified('Test is String').should.equal('test_is_string')
    })
  })
  describe("capitalized",function(){
    it('should turn to cap cased from downcased', function(){
      be.capitalized('test string').should.equal('Test String')
    })
    it('should turn to cap cased from upcased', function(){
      be.capitalized('TEST STRING').should.equal('Test String')
    })
    it('should turn to cap cased from mixcased', function(){
      be.capitalized('TeST StrING').should.equal('Test String')
    })
    
  })
})