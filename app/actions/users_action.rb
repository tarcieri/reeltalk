class UsersAction < Cramp::Action
  def start
    users = {:users => ChatServer.actor.users}.to_json
    render users
    finish
  end
end