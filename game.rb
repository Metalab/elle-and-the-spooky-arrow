require_relative 'screen'
require_relative 'device'
require_relative 'arrow'
require_relative 'joystick'
require_relative 'audio'
require_relative 'guy'
require_relative 'explosion'
require_relative 'collision'
require_relative 'score'

class Game
  def init
    @fps = 10
    @screen = Screen.new
    @device = Device.new(@screen)
    @arrow = Arrow.new(@screen)
    @guy = Guy.new(@screen)
    @audio.init_entities(@arrow)
    @collision = Collision.new(@arrow, @guy)
    @explosion = Explosion.new(@screen)
    @frame_count = 0

    # 0 - running
    # 1 - explosion
    # 2 - restart
    # 3 - end
    # 4 - init
    @game_state = 0
    @score = Score.new
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
        if @collision.collide?
          @guy.die!
          @arrow.die!
          @audio.arrow_off
          @audio.explosion
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
        @score.draw
        @game_state = 4 if @j1.state == :start
      when 3
        break
      when 4
        init
      end

      @game_state = 3 if @j1.state == :select
      @score.increase @frame_count/10
      @device.flush
      @j1.reset
      @frame_count += 1
      sleep(1/@fps.to_f)
    end
  end

  def self.run
    _game = new
    _game.init_once
    _game.init
    _game.run
  end
end

Game.run
