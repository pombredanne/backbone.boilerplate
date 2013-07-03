# node.js proxy server example for adding CORS headers to any existing http services.
# yes, i know this is super basic, that's why it's here. use this to help understand how http-proxy works with express if you need future routing capabilities
httpProxy = require("http-proxy")
express = require("express")
proxy = new httpProxy.RoutingProxy()
proxyOptions =
  host: "ats.borqs.com"
  port: 80

app = express()
allowCrossDomain = (req, res, next) ->
  console.log "allowingCrossDomain"
  res.header "Access-Control-Allow-Origin", "*"
  res.header "Access-Control-Allow-Methods", "GET,PUT,POST,DELETE"
  res.header "Access-Control-Allow-Headers", "X-Requested-With, Accept, Origin, Referer, User-Agent, Content-Type, Authorization, X-Mindflash-SessionID"
  
  # intercept OPTIONS method
  if "OPTIONS" is req.method
    res.send 200
  else
    next()

app.configure ->
  app.use allowCrossDomain

app.all "/*", (req, res) ->
  proxy.proxyRequest req, res, proxyOptions

app.listen 9001
console.log "#########\nListening on 9001\n##########"
