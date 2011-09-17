class ChatClient < Cramp::Websocket
  attr_reader :name
  
  on_data   :handle_data
  on_finish :handle_leave
    
  def handle_data(data)
    msg = JSON.parse data
    
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
    EM.schedule { render msg }
  end
end
