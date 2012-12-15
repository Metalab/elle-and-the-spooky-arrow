class Pixel
  def initialize(screen)
    @screen = screen
    @x = 0
    @y = 0
  end

  def action(action)
    case action
    when :right then @x += 1
    when :left then @x -= 1
    when :down then @y += 1
    when :down then @y -= 1
    end
  end

  def draw
    @screen[@x, @y] = true
  end
end