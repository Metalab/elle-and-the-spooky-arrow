class Collision
  def collide?(arrow, guy)
    front_pixel = arrow.body[4]
    back_pixel = guy.first

    arrow.lane == guy.lane && front_pixel[0] == back_pixel[0]
  end
end
