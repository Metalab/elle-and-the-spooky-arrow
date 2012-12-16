class Explosion
  def initialize(screen)
    @screen = screen
    @finished = false
    @explosion_frame = 0
    @frames = []
    @frames << [[3,4]]
    @frames << [[3,3], [3,4], [2,4], [4,4], [3,5]]
    @frames << [[2,3], [4,3], [2,5], [4,5]]
    @frames << [[2,2], [4,2], [5,3], [5,5], [4,6], [2,6], [1,5], [1,3], [3,4]]
    @frames << [[2,1], [3,1], [4,1], [5,2], [6,3], [6,4], [6,5], [5,6], [4,7], [3,7], [2,7], [1,6], [0,5], [0,4], [0,3], [1,2], [2,3], [4,3], [4,5], [2,5]]
    @frames << [[2,0], [4,0], [5,1], [6,2], [7,3], [7,5], [6,6], [5,7], [4,8], [2,8], [1,7], [0,6], [0,2], [1,1], [7,0], [7,8], [0,8], [0,0]]
    @frames << [[7,0], [7,8], [0,8], [0,0]]
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
    @finished = true if @frames.size - 1
  end
end
