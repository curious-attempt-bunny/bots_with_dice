class BrutePlayer < Player
  def strategy(victim, last_hit)
    if accumulated_damage >= 100
      :attack
    else
      :roll
    end
  end
end