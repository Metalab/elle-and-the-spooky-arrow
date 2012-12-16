class Score
  def initialize
    @score = 0
  end

  def increase(count)
    @score += count
  end

  def draw
    puts "SCORE #{@score}"
  end

end
