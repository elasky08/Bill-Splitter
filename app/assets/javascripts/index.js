// connect to server like normal
var dispatcher = new WebSocketRails('localhost:3000/websocket');

// subscribe to the channel
var channel = dispatcher.subscribe('channel_name');

// bind to a channel event
channel.bind('event_name', function(data) {
  console.log('channel event received: ' + data);
});