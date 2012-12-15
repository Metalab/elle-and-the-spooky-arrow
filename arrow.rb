class Arrow
  def initialize(screen)
    @screen = screen
    @speed = 1
    @direction = 1
    @body = [               [2,0],
              [0,1], [1,1], [2,1], [3,1],
                            [2,2]
            ]
  end

  def update
    @body.each do |el|
      el[0] = el[0] + (@speed * @direction)
      el[1] = el[1] + (@speed * @direction)
    end
  end

  def draw
    @body.each do |el|
      @screen[el[0], el[1]] = true
    end
  end
end
