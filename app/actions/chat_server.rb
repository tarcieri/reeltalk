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
    @users = {}
  end
  
  def register(name, client)
    @users[name] = client
    publish :control, name, 'joined the chat room'
  end
  
  def unregister(name)
    @users.delete name
    publish :control, name, 'left the chat room'
  end
  
  def send_message(user, str)
    publish :message, user, str
  end
  
  def users
    @users.map { |name, _| {:name => name} }
  end
  
  def publish(type, user, str)
    msg = {:action => type, :user => user, :message => str}.to_json
    
    @users.each do |_, user|
      user.send_message msg
    end
  end
end