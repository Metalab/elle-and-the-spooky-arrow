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
    when :up then @y -= 1
    end
  end

  def draw
    @screen[@y, @x] = true
  end
end