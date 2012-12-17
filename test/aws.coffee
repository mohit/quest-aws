aws = require "#{__dirname}/../index"
quest = require 'quest'
assert = require 'assert'

describe 'quest', ->
  safe_err = (err) ->
    err = new Error err if err? and err not instanceof Error
    err
  describe 'signing', ->
    it 'test signing', (done) ->
    
      # Example request from 
      # http://s3.amazonaws.com/doc/s3-developer-guide/RESTAuthentication.html 

      options = 
        uri: "https://aws.amazon.com/quotes/nelson",
        method: 'PUT'
        aws: 
          key: '44CF9590006BF252F707',
          secret: 'OtxrzxIsfpFjA7SwPzILwy8Bw21TLhquhboDYROV',
        headers: 
          "X-Amz-Meta-Author": 'foo@bar.com',
          "X-Amz-Magic": 'abracadabra',
          "content-type": 'text/html',
          "content-md5": 'c8fdb181845a4ca6b8fec737b3581d76'
          "date":  'Thu, 17 Nov 2005 18:49:58 GMT',

      assert.equal aws.handlers.awsSignature(options), 'AWS 44CF9590006BF252F707:jZNOcbfWmD/A/f3hSvVzXZjM2HU='
      done()

    it 'put document using a signed aws request', (done) ->
    
      options = 
        uri: "https://s3.amazonaws.com/#{process.env.AWS_BUCKET}/test",
        method: 'PUT'
        body: "this is a test text file"
        aws: 
          key: process.env.AWS_KEY
          secret: process.env.AWS_SECRET
        headers: 
          "accept": 'text/html'
          "content-type": 'text/plain'
      
      quest.use aws
      quest options, (err, resp, body) ->
        assert not err, "Has error #{err}"
        assert.equal resp?.statusCode, 200, "Status code should be 200, is #{resp?.statusCode}"
        done()

    it 'make signed get request', (done) ->
    
      options = 
        uri: "https://s3.amazonaws.com/#{process.env.AWS_BUCKET}/test",
        method: 'GET'
        aws: 
          key: process.env.AWS_KEY
          secret: process.env.AWS_SECRET
        headers: 
          "accept": 'text/html'
      
      quest.use aws
      quest options, (err, resp, body) ->
        assert not err, "Has error #{err}"
        assert.equal resp?.statusCode, 200, "Status code should be 200, is #{resp?.statusCode}"
        assert.equal body, "this is a test text file"
        done()

    it 'remove test file from aws', (done) ->
    
      options = 
        uri: "https://s3.amazonaws.com/#{process.env.AWS_BUCKET}/test",
        method: 'DELETE'
        aws: 
          key: process.env.AWS_KEY
          secret: process.env.AWS_SECRET
        headers: 
          "accept": 'text/html'
      
      quest.use aws
      quest options, (err, resp, body) ->
        assert not err, "Has error #{err}"
        assert.equal resp?.statusCode, 204, "Status code should be 204, is #{resp?.statusCode}"
        done()
