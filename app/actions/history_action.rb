class HistoryAction < Cramp::Action
  def start
    history = {:history => ChatServer.actor.history}.to_json
    render history
    finish
  end
end