crypto         = require 'crypto'
_              = require 'underscore'
url            = require 'url'
sys            = require 'sys'

parse = url.parse
SIGNING_METHOD = "sha1"

awsSignature = (options) ->
  signingString = stringToSign(options)
  signature = crypto.createHmac(SIGNING_METHOD, options.aws.secret).update(signingString).digest('base64')

  # add authorization header to the request
  options.headers.authorization = "AWS " + options.aws.key + ":" + signature

  console.log options.headers.authorization

  return options.headers.authorization 

stringToSign = (options) ->

  # ordered string used for as secret in the Authorization header
  signingString = [ 
    options.method,
    options.headers['Content-Md5'],
    options.headers['Content-Type'],
    options.headers['Date']
  ]

  for header in canonicalizeAmazonHeaders(options)
    signingString.push(header)

  signingString.push(parse(options.uri).pathname)

  return signingString.join('\n')

canonicalizeAmazonHeaders = (options) ->
  header_names = _(options.headers).chain().keys().filter((key) -> key.toLowerCase().indexOf('x-amz') is 0).value()
  headers = (hdr.toLowerCase() + ":" + options.headers[hdr] for hdr in header_names).sort()
  return headers

aws = {}
aws.awsSignature = awsSignature
module.exports = aws 
