require 'rubygems'
require 'bundler/setup'
require 'reel'
require 'reeltalk/version'

module Reeltalk
  PUBLIC_ROOT  = Pathname.new File.expand_path("../../public", __FILE__)
  PUBLIC_FILES = Dir[PUBLIC_ROOT.join("**", "*")].map { |f| f.sub(/^#{PUBLIC_ROOT}\//, '') }
  
  class Server < Reel::Server
    include Celluloid::Logger

    def initialize(host = "127.0.0.1", port = 1234)
      info "Reeltalk starting on http://#{host}:#{port}"
      super(host, port, &method(:on_connection))
    end

    def on_connection(connection)
      while request = connection.request
        case request
        when Reel::Request
          route_request connection, request
        when Reel::WebSocket
          info "Received a WebSocket connection"
          route_websocket request
        end
      end
    end

    def route_request(connection, request)
      if request.url == "/"
        return render_asset(connection, "index.html")
      elsif PUBLIC_FILES.include?(request.url.sub(/^\//, ''))
        return render_asset(connection, request.url)
      end

      info "404 Not Found: #{request.path}"
      connection.respond :not_found, "Not found"
    end

    def route_websocket(socket)
      if socket.url == "/timeinfo"
        TimeClient.new(socket)
      else
        info "Received invalid WebSocket request for: #{socket.url}"
        socket.close
      end
    end

    def render_asset(connection, path)
      info "200 OK: #{path}"
      connection.respond :ok, File.read(PUBLIC_ROOT.join(path.sub(/^\/+/, '')))
    end
  end
end