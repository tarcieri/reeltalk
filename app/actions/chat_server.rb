require 'celluloid'

class ChatServer
  include Celluloid
  
  def self.start
    supervise_as :chat_server
  end
  
  def self.actor
    Celluloid::Actor[:chat_server]
  end
    
  def initialize
    @clients = {}
  end
  
  def register(name, client)
    @clients[name] = client
    publish :control, name, 'joined the chat room'
  end
  
  def unregister(name)
    @clients.delete name
    publish :control, name, 'left the chat room'
  end
  
  def send_message(user, str)
    publish :message, user, str
  end
  
  def publish(type, user, str)
    msg = {:action => type, :user => user, :message => str}.to_json
    
    @clients.each do |_, client|
      client.send_message msg
    end
  end
end