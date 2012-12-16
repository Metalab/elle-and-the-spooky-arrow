require_relative 'screen'
require_relative 'device'
require_relative 'arrow'
require_relative 'joystick'
require_relative 'audio'
require_relative 'guy'
require_relative 'explosion'
require_relative 'collision'

class Game
  def init
    @fps = 10
    @screen = Screen.new
    @device = Device.new(@screen)
    @arrow = Arrow.new(@screen)
    @guy = Guy.new(@screen)
    @audio.init_entities(@arrow)
    @collision = Collision.new
    @explosion = Explosion.new(@screen)
    @frame_count = 0
    @game_state = 0 # 0 - running, 1 - explosion, 2 end
  end

  def init_once
    @j1 = Joystick.new
    @audio = Audio.new('data/noise.pd')
  end

  def run
    loop do

      case @game_state
      # running
      when 0
        if @collision.collide?(@arrow, @guy)
          @guy.die!
          @arrow.die!
          @audio.arrow_off
          @game_state = 1
        end

        @arrow.update(@frame_count)
        @arrow.draw
        @audio.update_arrow

        @guy.update(@j1.state)
        @guy.draw
        @audio.update_j1(@j1.state)
      # explosion
      when 1
        @game_state = 2 if @explosion.finished?
        @explosion.draw
      # end
      when 2
        break
      end

      @device.flush
      @j1.reset
      @frame_count += 1
      sleep(1/@fps.to_f)
    end
  end

  def self.run
    g = new
    g.init_once
    g.init
    g.run
  end
end

Game.run
