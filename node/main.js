var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

app.get('/', function(req, res){
  res.sendFile(__dirname + '/index.html');
});

io.on('connection', function(socket){
  console.log('a user connected');
  socket.emit('get room');
  socket.on('subscribe', function(data) {
	  console.log('subscribe ' + data.room);
	  socket.join(data.room);
  });
  socket.on('unsubscribe', function(data) {
      console.log('unsubscribe ' + data.room);
      socket.leave(data.room);
  });
  socket.on('disconnect', function(){
	  console.log('user disconnected');
  });
  socket.on('chat message', function(msg){
	  
//	  //给除了自己以外的客户端广播消息
//	  socket.broadcast.emit("msg",{data:"hello,everyone"}); 
//	  //给所有客户端广播消息
//	  io.sockets.emit("msg",{data:"hello,all"});
//	  //不包括自己
//	  socket.broadcast.to('group1').emit('event_name', data);
//	  //包括自己
//	  io.sockets.in('group1').emit('event_name', data);
//	  //获取所有房间（分组）信息
//	  io.sockets.manager.rooms
//	  //获取此socketid进入的房间信息
//	  io.sockets.manager.roomClients[socket.id]
//	  //获取particular room中的客户端，返回所有在此房间的socket实例
//	  io.sockets.clients('particular room')
	  //给自己所在的rooms发消息
	  for(var room in socket.rooms) {
		  if(room != socket.id){
			  io.to(room).emit('chat message', msg);
		  }
	  }
	  socket.join('cached');
//	  console.log(JSON.stringify(socket.rooms));
//	  io.emit('chat message', msg);
  });
});

http.listen(80, function(){
  console.log('listening on *:80');
});