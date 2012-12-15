require_relative 'screen'
require_relative 'device'
require_relative 'arrow'
require_relative 'joystick'
require_relative 'audio'
require_relative 'guy'

class Game
  @@fps = 25

  def self.run
    screen = Screen.new
    device = Device.new(screen)
    audio = Audio.new('data/noise.pd')
    j1 = Joystick.new
    arrow = Arrow.new(screen)
    guy = Guy.new(screen)
    frame_count = 0

    loop do
      arrow.update(frame_count)
      arrow.draw

      guy.update
      guy.draw
      device.flush
      frame_count += 1
      sleep(1/@@fps.to_f)
    end
  end
end

Game.run
