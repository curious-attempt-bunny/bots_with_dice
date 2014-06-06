class ZenoPlayer < Player
  def strategy(victim, last_hit)
    if accumulated_damage >= victim.hit_points / 2
      :attack
    else
      :roll
    end
  end
end