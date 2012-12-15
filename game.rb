class Game

  def self.run
    screen = Screen.new
    device = Device.new(screen)
    j1 = Joystick.new
    j2 = Joystick.new
  end
end

Game.run