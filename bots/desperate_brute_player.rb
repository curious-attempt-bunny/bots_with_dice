class DesperateBrutePlayer < Player
  def strategy(victim, last_hit)
    if victim.hit_points <= 40
      :roll
    elsif accumulated_damage >= 21
      :attack
    else
      :roll
    end
  end
end