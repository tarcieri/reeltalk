require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Variety do
  let(:server) { Rack::MockRequest.new(Variety::App) }
  
  context "/" do
    it "should return a 200 response" do
      response = server.get('/')
      response.status.should == 200
    end
  end
end
