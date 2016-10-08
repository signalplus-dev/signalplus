let dispatcher;

export default function getDispatcher() {
  if (dispatcher) return dispatcher;

  if (window && window.WebSocketRails){
    dispatcher = new window.WebSocketRails(`${process.env.DOMAIN}/websocket`, false);

    dispatcher.on_open = function(data) {
      console.log('Connection has been established');
    }

    return dispatcher;
  }

  return {};
};
