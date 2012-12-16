class Collision
  def collide?(arrow, guy)
    arrow_front_col = arrow.body[4][0]
    guy_back_col = guy.body[0][0]

    (arrow.lane == guy.lane) && (arrow_front_col == guy_back_col ||
                                 arrow_front_col == guy_back_col + 1)
  end
end
