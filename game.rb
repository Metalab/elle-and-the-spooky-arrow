require_relative 'screen'
require_relative 'device'
require_relative 'arrow'
require_relative 'joystick'
require_relative 'audio'
require_relative 'guy'
require_relative 'collision'

class Game
  @@fps = 20

  def self.run
    screen = Screen.new
    device = Device.new(screen)
    audio = Audio.new('data/noise.pd')
    j1 = Joystick.new
    arrow = Arrow.new(screen)
    guy = Guy.new(screen)
    collision = Collision.new
    frame_count = 0

    loop do

      if collision.collide?(arrow, guy)
        #explosion
        guy.die!
        arrow.die!
      end

      arrow.update(frame_count)
      arrow.draw

      guy.update(j1.action)
      guy.draw
      device.flush
      frame_count += 1
      sleep(1/@@fps.to_f)
    end
  end
end

Game.run
