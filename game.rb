require_relative 'screen'
require_relative 'device'
require_relative 'arrow'
require_relative 'joystick'
require_relative 'audio'
require_relative 'guy'
require_relative 'explosion'
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
    explosion = Explosion.new(screen)
    frame_count = 0
    game_state = 0 # 0 - running, 1 - explosion, 2 end

    loop do

      case game_state
      # running
      when 0
        if collision.collide?(arrow, guy)
          guy.die!
          arrow.die!
          game_state = 1
        end

        arrow.update(frame_count)
        arrow.draw

        guy.update(j1.state)
        audio.update(j1.state)
        guy.draw
      # explosion
      when 1
        game_state = 2 if explosion.finished?
        explosion.draw
      # end
      when 2
        break
      end

      device.flush
      j1.reset
      frame_count += 1
      sleep(1/@@fps.to_f)
    end
  end
end

Game.run
