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
	
	theInterval = setInterval theLoop, 500
	$('#thedata').data 'theInt', theInterval
	$('#thedata').data 'counter', 0
    
theLoop = () ->
	console.log $('#thedata').data('theInt')
	x = $('#thedata').data 'counter'
	y = x+1
	$('#thedata').data 'counter', y
	#clearInterval $('body').data('theInt')
	console.log $('#thedata').data('counter')
	$('body').find('#frames').append '<div class="wrap"><iframe style="border:none;" width="100" height="100" src="http://pepr.no.de/sqr"></iframe></div>'
	if $('#thedata').data('counter') > 97
		clearInterval $('#thedata').data('theInt')
		alert 'called'
