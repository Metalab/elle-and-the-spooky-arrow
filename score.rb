class Score
  def initialize(screen)
    @screen = screen
    @score = 0
  end

  def increase(count)
    @score += count
  end

  def draw
    puts "SCORE #{@score}"

    @cols = (@score / @screen.height)
    @mod = @score % @screen.height

    0.upto(@cols - 1) do |col|
      @screen.col(col, true)
    end

    0.upto(@mod) do |row|
      @screen[@cols+1, row] = true
    end

  end
end
