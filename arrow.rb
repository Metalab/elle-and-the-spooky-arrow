class Arrow
  def initialize(screen)
    @screen = screen
    @speed = 1
    @direction = 1
    @lane = 0
    @body = [
              [2, Proc.new { @lane + 0 }], [0, Proc.new { @lane + 1 }],
              [1, Proc.new { @lane + 1 }], [2, Proc.new { @lane + 1 }],
              [3, Proc.new { @lane + 1 }], [2, Proc.new { @lane + 2 }]
            ]
  end

  def update(frame_count)
    @lane = [0, 3, 6].sample if frame_count % 15 == 0
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
