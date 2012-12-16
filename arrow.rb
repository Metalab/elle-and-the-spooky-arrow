class Arrow
  attr_reader :body, :lane

  def initialize(screen)
    @alive = true
    @screen = screen
    @speed = 2
    @direction = 1
    @lane = 0
    @body = [
              [16 + 2, Proc.new { @lane * 3 + 0 }], [16 + 0, Proc.new { @lane * 3 + 1 }],
              [16 + 1, Proc.new { @lane * 3 + 1 }], [16 + 2, Proc.new { @lane * 3 + 1 }],
              [16 + 3, Proc.new { @lane * 3 + 1 }], [16 + 2, Proc.new { @lane * 3 + 2 }]
            ]
  end

  def die!
    @alive = false
  end

  def update(frame_count)
    @lane = [0, 1, 2].sample if frame_count % 15 == 0
    @body.each do |el|
      el[0] = (el[0] + (@speed * @direction)) % @screen.width
    end
  end

  def draw
    if @alive
      @body.each do |el|
        @screen[el[0], el[1].call] = true
      end
    end
  end
end
