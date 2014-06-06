class TacticalPlayer < Player

  attr_reader :victim

  def strategy(victim, last_hit)
    @victim = victim
    return :roll if desperate?
    return :roll if close?
    return risky_strategy if worried?
    basic_strategy
  end

  def optimal_target
    21
  end

  def basic_strategy
    if accumulated_damage >= optimal_target
      :attack
    else
      :roll
    end
  end

  def risky_strategy
    # Abstract method
    basic_strategy
  end

  def close?
    false
  end

  def worried?
    false
  end

  def expected_hurt_per_round
    8
  end

  def expected_hurt_per_hit
    23
  end

  def desperate?
    (hit_points <= expected_hurt_per_hit)
  end

end

class CatchupTac < TacticalPlayer
  def worried?
    victim.hit_points - self.hit_points >= 23
  end

  def risky_strategy
    gap = (victim.hit_points - self.hit_points)
    if accumulated_damage >= gap || accumulated_damage >= 26
      :attack
    else
      :roll
    end
  end
end