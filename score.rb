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

    0.upto(@mod -1) do |row|
      @screen[@cols, row] = true
    end

  end
end
