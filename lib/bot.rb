class Bot < Player
  def strategy(victim, last_hit)
    roll?(hit_points, victim.hit_points, @rolls, accumulated_damage) ? :roll : :attack
  end
end