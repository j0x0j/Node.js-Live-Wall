$ ->
	entry_el = $('#chatter')
	display = $('display')
	controls = $('controls')
	_body = $('body')
	pad1 = $('#pad_1')
	pad2 = $('#pad_2')
	pad3 = $('#pad_3')
	socket = new io.connect()
	
	socket.on 'news', (data) ->
		display = $('#display')
		display.append '<p>' + data.hello + '</p>'
	
	socket.on 'change-color', (color) ->
	    console.log color
	    _body.css 'background', color
	
	socket.on 'message', (message) ->
		console.log message
		display.append '<p>' + message + '</p>'
		entry_el.prop 'value'
	
	entry_el.keypress (event) ->
		if event.keyCode != 13
			return
		msg = entry_el.prop 'value'
		if msg
			socket.emit 'message', {mymsg: msg}
			entry_el.prop 'value', ''
			entry_el.focus()
			display.append '<p>' + msg + '</p>'
			
	pad1.click ->
		#console.log 'hey hey'
		socket.emit 'message', {mymsg: 'x red 1'}
	
	pad2.click ->
		#console.log 'hey hey 2'
		socket.emit 'message', {mymsg: 'x green 2'}
	
	pad3.click ->
		#console.log 'hey hey 3'
		socket.emit 'message', {mymsg: 'x blue 3'}