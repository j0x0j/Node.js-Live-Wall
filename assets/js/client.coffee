$ ->
	entry_el = $('#chatter')
	display = $('display')
	controls = $('controls')
	_body = $('body')
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