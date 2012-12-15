require_relative 'screen'
require_relative 'device'
require_relative 'arrow'
require_relative 'joystick'
require_relative 'audio'

class Game
  @@fps = 25

  def self.run
    screen = Screen.new
    device = Device.new(screen)
    audio = Audio.new('data/noise.pd')
    j1 = Joystick.new
    arrow = Arrow.new(screen)

    loop do
      #p1.action(j1.action)
      arrow.draw
      device.flush
      sleep(1/@@fps.to_f)
    end
  end
end

Game.run
