class LuckyNumberPlayer < Player
  def strategy(victim, last_hit)
    if accumulated_damage >= 21
      :attack
    else
      :roll
    end
  end
end