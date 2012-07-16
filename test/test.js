var should = require('should'),
    be = require('../dist/be');

be.monkeyPatched(String);
be.monkeyPatched(Number);

describe("Be", function () {
  /* String Functions */
  describe("plainText", function () {
    it('should convert HTML to plain text', function () {
      be.plainText('<div><span>Testing</span><br>plaintext</div>').should.equal("Testing\nplaintext")
    });
    it('should work as expected when monkeyPatched()', function () {
      '<div><span>Testing</span><br>plaintext</div>'.plainText().should.equal("Testing\nplaintext")
    });
  })
  describe("safe", function () {
    it('should escape SQL injections unsafe chars', function () {
      be.safe("' or ''='").should.equal("\\' or \\'\\'=\\'");
    });
    it('should escape XSS attack unsafe chars', function () {
      be.safe('"><script>alert("XSS")</script>').should.equal('\\"\\>\\<script\\>alert\\(\\"XSS\\"\\)\\</script\\>');
    });
    it('should work as expected when monkeyPatched()', function () {
      '"><script>alert("XSS")</script>'.safe().should.equal('\\"\\>\\<script\\>alert\\(\\"XSS\\"\\)\\</script\\>');
    });
  });
  describe("sanitized", function () {
    it('should sanitize SQL injections unsafe chars', function () {
      be.sanitized("' or ''='").should.equal(" or =");
    });
    it('should sanitize XSS attacks unsafe chars', function () {
      be.sanitized('"><script>alert("XSS")</script>').should.equal('scriptalertXSS/script');
    });
    it('should work as expected when monkeyPatched()', function () {
      '"><script>alert("XSS")</script>'.sanitized().should.equal('scriptalertXSS/script');
    });
  });
  describe("stripped", function () {
    it('should remove leading and trailing whitespace', function () {
      be.stripped(' test_string ').should.equal('test_string');
    });
    it('should not remove whitespace in the middle', function () {
      be.stripped('test is string').should.equal('test is string');
    });
    it('should work as expected when monkeyPatched()', function () {
      'test is string'.stripped().should.equal('test is string');
    });
  });
  describe("slugified", function () {
    it('should remove leading and trailing whitespace', function () {
      be.slugified(' tests string ').should.equal('tests_string');
    });
    it('should replace whitespace in the middle with underscore', function () {
      be.slugified('test is string').should.equal('test_is_string');
    });
    it('should only leave underscore and a-z', function () {
      be.slugified('test, is string!!!').should.equal('test_is_string');
    });
    it('should downcase', function () {
      be.slugified('Test is String').should.equal('test_is_string');
    });
    it('should work as expected when monkeyPatched()', function () {
      'Test is String'.slugified().should.equal('test_is_string');
    });
  });
  describe("capitalized", function () {
    it('should turn to cap cased from downcased', function () {
      be.capitalized('test string').should.equal('Test String');
    });
    it('should turn to cap cased from upcased', function () {
      be.capitalized('TEST STRING').should.equal('Test String');
    });
    it('should turn to cap cased from mixcased', function () {
      be.capitalized('TeST StrING').should.equal('Test String');
    });
    it('should work as expected when monkeyPatched()', function () {
      'TeST StrING'.capitalized().should.equal('Test String');
    });
  });

  /* Number Functions */
  describe("twoDigits", function () {
    it('should return only two digits as decimal for floats', function () {
      be.twoDecimals(3.141592653589793).should.equal(3.14);
    });
    it('should work as expected when monkeyPatched()', function () {
      (3.141592653589793).twoDecimals().should.equal(3.14);
    });
  });
  describe("between", function () {
    it('should return numbers between given range', function () {
      be.between(1, 10).should.be.within(1, 10)
    });
  });
  describe("percentOf", function () {
    it('should return the (1st value) percent of (2nd value)', function () {
      be.percentOf(4, 1000).should.equal(0.4);
    });
    it('should work as expected when monkeyPatched()', function () {
      (4).percentOf(1000).should.equal(0.4);
    });
  });
  describe("shownAsTime", function () {
    it('should return the number as a short time string', function () {
      be.shownAsTime(14400000).should.equal('04:00:00');
    });
    it('should return 00:00:00 when the argument is not a number', function () {
      be.shownAsTime('string').should.equal('00:00:00');
    });
    it('should work as expected when monkeyPatched()', function () {
      (14400000).shownAsTime().should.equal('04:00:00');
    });
  });
  describe("sentence", function () {
    it('should return a sentence from a list of string', function () {
      be.sentence('the','test','string').should.equal('the, test and string');
    });
    it('should return a sentence from a array of string', function () {
      be.sentence(['the','test','string']).should.equal('the, test and string');
    });
  });
});
