require 'json'

module Reeltalk
  class Client
    include Celluloid::IO
    include Celluloid::Logger

    attr_reader :socket

    def initialize(socket)
      @socket = socket
      @nickname = nil

      async.run
    end

    def run
      while message = JSON.parse(@socket.read)
        dispatch message['action'], message
      end
    rescue EOFError
      info "#{nickname} disconnected"
      terminate
    end

    def dispatch(action, params = {})
      case action
      when 'join'
        @nickname = params['user']
        info "#{nickname} joined"
      else
        warn "unknown command '#{action}'"
      end
    end

    def nickname
      @nickname || "unregistered user"
    end
  end
end