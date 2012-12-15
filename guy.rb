class Guy
  def initialize(screen)
    @screen = screen
    @speed = 1
    @direction = 1
    @lane = 0
    @body = [
              [0, Proc.new { @lane * 3 + 0 }], [1, Proc.new { @lane * 3 + 0 }],
              [0, Proc.new { @lane * 3 + 1 }], [0, Proc.new { @lane * 3 + 2 }]
            ]
  end

  def update(action)
    case action
    when :up    then @lane = [@lane - 1, 0].max
    when :down  then @lane = [@lane + 1, 2].min
    end

    @body.each do |el|
      el[0] = (el[0] + (@speed * @direction)) % @screen.width
    end
  end

  def draw
    @body.each do |el|
      @screen[el[0], el[1].call] = true
    end
  end
end
