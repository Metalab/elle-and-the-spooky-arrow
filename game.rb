require_relative 'screen'
require_relative 'device'
require_relative 'pixel'
require_relative 'joystick'

class Game
  @@fps = 25

  def self.run
    screen = Screen.new
    device = Device.new(screen)
    j1 = Joystick.new
    p1 = Pixel.new(screen)

    loop do
      _start = Time.now.usec

      p1.action(j1.action)
      p1.draw
      device.flush

      _end = Time.now.usec
      puts "#{(_end - _start)/1000.0} ms"

      sleep(1/@@fps.to_f)
    end
  end
end

Game.run
