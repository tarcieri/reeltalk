class ChatClient < Cramp::Websocket
  attr_reader :name
  
  on_start  :init_channel
  on_data   :handle_data
  on_finish :handle_leave
  
  def init_channel
    # Channels are a thread-safe way to send messages to the event loop
    @channel = EM::Channel.new
    @sub = @channel.subscribe { |msg| render msg }
  end
    
  def handle_data(data)
    msg = JSON.parse data
    p msg
    
    case msg['action']
    when 'join'    then handle_join(msg)
    when 'message' then handle_message(msg)
    end
  end
  
  def handle_join(msg)
    @name = msg['user']
    ChatServer.actor.register(@name, self)
  end
  
  def handle_leave
    @channel.unsubscribe @sub
    ChatServer.actor.unregister(@name)
  end
  
  def handle_message(msg)
    ChatServer.actor.send_message @name, msg['message']
  end
  
  def send_message(msg)
    @channel.push msg
  end
end
