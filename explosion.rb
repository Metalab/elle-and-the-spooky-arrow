class Explosion
  def initialize(screen)
    @screen = screen
    @finished = false
    @explosion_frame = 0
    @frames = []
    @frames << [[3,4]]
    @frames << [[3,3], [3,4], [2,4], [4,4], [3,5]]
    @frames << [[2,3], [4,3], [2,5], [4,5]]
    @frames << [[2,2], [3,2], [4,2], [5,3], [6,4], [5,5], [4,6], [3,6], [2,6], [1,5], [1,4], [1,3]]
  end

  def finished?
    @finished
  end

  def draw
    @frames[@explosion_frame].each do |el|
      [0, 8, 16, 24].each do |start|
        @screen[start + el[0], el[1]] = true
      end
    end
    @explosion_frame += 1
    @finished = true if @explosion_frame == 3
  end
end
