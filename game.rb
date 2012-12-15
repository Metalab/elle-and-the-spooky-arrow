require './screen'
require './device'
require './pixel'
require './joystick'

class Game
  @@fps = 25

  def self.run
    screen = Screen.new
    device = Device.new(screen)
    j1 = Joystick.new
    p1 = Pixel.new(screen)

    loop {
      _start = Time.now.usec

      p1.action(j1.action)
      p1.draw
      device.flush
      sleep(1/@@fps.to_f)

      _end = Time.now.usec
      puts "#{(_end - _start)/1000.0} ms"
    }
  end
end

Game.run
