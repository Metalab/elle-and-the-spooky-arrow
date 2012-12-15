class Pixel
  def initialize(screen)
    @screen = screen
    @x = 0
    @y = 0
  end

  def action(action)
    case action
    when :right then  @x = (@x + 1) % @screen.width
    when :left then   @x = (@x - 1) % @screen.width
    when :down then   @y = (@y + 1) % @screen.height
    when :up then     @y = (@y - 1) % @screen.height
    end
  end

  def draw
    @screen[@x, @y] = true
  end
end
