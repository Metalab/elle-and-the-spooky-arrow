require './screen'
require './device'
require './pixel'
require './joystick'

class Game
  @@fps = 25

  def self.run
    loop {
      pixel = []

      screen = Screen.new
      device = Device.new(screen)
      j1 = Joystick.new
      j1.work
      p1 = Pixel.new(screen)

      p1.action(j1.action)
      p1.draw

      d.flush
      sleep(1/@@fps.to_f)
    }
  end
end

Game.run