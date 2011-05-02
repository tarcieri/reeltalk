require 'sinatra'

module Variety
  class App < Sinatra::Base
    set :static, true
    set :public, File.dirname(__FILE__) + '/public'
    
    get '/' do
      File.read File.expand_path('../../public/index.html', __FILE__)
    end
  end
end