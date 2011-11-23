(function() {
  var app, assets, automate, express, getSocketId, io, port, _;
  assets = require('connect-assets');
  express = require('express');
  app = express.createServer();
  io = require('socket.io').listen(app);
  _ = require('underscore');
  app.configure(function() {
    app.use(express.bodyParser());
    app.use(assets());
    app.use(express.logger());
    return app.use(express.static('public'));
  });
  getSocketId = function(which, clients) {
    var i, key, val;
    which = which - 1;
    i = 0;
    for (key in clients) {
      val = clients[key];
      i++;
      if (i - 1 === which) {
        return val.id;
      }
    }
  };
  automate = function(the_socket, socket) {
    var random;
    random = '#' + Math.floor(Math.random() * 16777215).toString(16);
    the_socket.emit('change-color', random);
    return socket.broadcast.emit('change-color', random);
  };
  io.sockets.on('connection', function(socket) {
    var clients, the_socket;
    clients = io.sockets.sockets;
    the_socket = io.sockets.socket(socket.id);
    socket.emit('news', {
      hello: 'type a color'
    });
    return socket.on('message', function(message) {
      var key, the_x_socket, val, _chunks, _first_client, _message;
      for (key in clients) {
        val = clients[key];
        _first_client = val.id;
        break;
      }
      _message = message.mymsg;
      _chunks = _message.split(" ");
      switch (_chunks[0].toLowerCase()) {
        case 'all':
          the_socket.emit('change-color', _chunks[1]);
          socket.broadcast.emit('change-color', _chunks[1]);
          return socket.broadcast.emit('news', {
            hello: _chunks[1]
          });
        case 'me':
          return the_socket.emit('change-color', _chunks[1]);
        case 'first':
          io.sockets.socket(_first_client).emit('change-color', _chunks[1]);
          socket.broadcast.emit('news', {
            hello: _chunks[1]
          });
          return console.log(_first_client);
        case 'x':
          the_x_socket = io.sockets.socket(getSocketId(_chunks[2], clients));
          return the_x_socket.emit('change-color', _chunks[1]);
      }
    });
  });
  app.get('/', function(req, res) {
    return res.render("index.jade", {
      title: 'Pepper'
    });
  });
  app.listen(port = process.env.PORT || 5000);
  console.log("Now listening on port " + port + "...");
}).call(this);
