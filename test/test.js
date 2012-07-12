var should = require('should'),
    be = require('../dist/be.js');

describe("Be", function(){
  describe(" strip",function(){
    it('should remove leading and trailing whitespace', function(){
      be.strip(' test_string ').should.equal('test_string')
    })
    it('should not remove whitespace in the middle', function(){
      be.strip('test is string').should.equal('test is string')
    })
  })
})