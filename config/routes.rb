# Check out https://github.com/joshbuddy/http_router for more information on HttpRouter
HttpRouter.new do
  add('/').to(HomeAction)
  get('/users').to(UsersAction)
  get('/history').to(HistoryAction)
  get('/websocket').to(ChatClient)
end
