class HomeAction < Cramp::Action
  def start
    render File.read(Variety::Application.root('public/index.html'))
    finish
  end
end
