class History
  DEFAULT_BACKLOG = 50
  
  def initialize(backlog = DEFAULT_BACKLOG)
    @timeline, @backlog = [], DEFAULT_BACKLOG
  end
  
  def push(message)
    @timeline << message
    @timeline.shift if @timeline.size > @backlog
  end
  alias_method :<<, :push
  
  def to_a
    @timeline
  end
  
  def to_json(opts = nil)
    @timeline.to_json(opts)
  end
end