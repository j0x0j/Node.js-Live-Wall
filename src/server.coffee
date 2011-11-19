assets  = require 'connect-assets'
express = require 'express'
app = express.createServer()
io = require('socket.io').listen(app)
_ = require 'underscore'

app.configure ->
  app.use express.bodyParser()
  app.use assets()
  app.use express.logger()
  app.use express.static 'public'

# Helpers

getSocketId = (which, clients) ->
	which = which - 1
	i = 0
	for key,val of clients
		i++
		if i-1 is which
			 return val.id

automate = (the_socket, socket) -> 
    random = '#'+Math.floor(Math.random()*16777215).toString(16) 
    the_socket.emit 'change-color', random 
    socket.broadcast.emit 'change-color', random
    #setInterval automate(the_socket, socket), 2000
	
io.sockets.on 'connection', (socket) ->
	clients = io.sockets.sockets
	the_socket = io.sockets.socket socket.id
	socket.emit 'news', {hello: 'type a color'}
	socket.on 'message', (message) ->
		for key, val of clients
		    _first_client = val.id
		    break

	    _message = message.mymsg
	    _chunks = _message.split " "
	    #console.log(_message)
	    switch _chunks[0].toLowerCase()
	        when 'all' 
	            the_socket.emit 'change-color', _chunks[1] 
	            socket.broadcast.emit 'change-color', _chunks[1]
	            socket.broadcast.emit 'news', {hello: _chunks[1]}
	        when 'me'
	            the_socket.emit 'change-color', _chunks[1]
	        when 'first'
	            io.sockets.socket(_first_client).emit 'change-color', _chunks[1]
	            socket.broadcast.emit 'news', {hello: _chunks[1]}
	            console.log _first_client
	        #when 'random' 
	            #console.log 'random'
	            #automate the_socket, socket
	        when 'x'
	            the_x_socket = io.sockets.socket getSocketId _chunks[2], clients
	            the_x_socket.emit 'change-color', _chunks[1]

app.get '/', (req, res) ->
	res.render "index.jade", title: 'Pepper'

app.listen port = process.env.PORT || 5000
console.log "Now listening on port #{port}..."