aws = require "#{__dirname}/../index"
assert = require 'assert'

describe 'quest', ->
  safe_err = (err) ->
    err = new Error err if err? and err not instanceof Error
    err
  describe "signing", ->
    it 'test signing', (done) ->
    
      # Example request from 
      # http://s3.amazonaws.com/doc/s3-developer-guide/RESTAuthentication.html 

      options = 
        uri: "https://aws.amazon.com/quotes/nelson",
        method: 'PUT'
        aws: 
          key: "44CF9590006BF252F707",
          secret: "OtxrzxIsfpFjA7SwPzILwy8Bw21TLhquhboDYROV",
        headers: 
          "X-Amz-Meta-Author": 'foo@bar.com',
          "X-Amz-Magic": 'abracadabra',
          "Content-Type": 'text/html',
          "Content-Md5": 'c8fdb181845a4ca6b8fec737b3581d76'
          Date:  'Thu, 17 Nov 2005 18:49:58 GMT',

      assert.equal aws.awsSignature(options), 'AWS 44CF9590006BF252F707:jZNOcbfWmD/A/f3hSvVzXZjM2HU='
      done()
