class Explosion
  def initialize(screen)
    @screen = screen
    @frames = []
    @frames << [[3,4]]
    @frames << [[3,3], [3,4], [2,4], [4,4], [3,5]]
  end

  def draw(explosion_frame)
    @frames[explosion_frame].each |el|
      @screen[el[0], el[1]] = true
    end
  end
end
