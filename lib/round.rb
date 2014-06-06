class Round

  def initialize(players)
    @players = players
    @turn_counter = 0
  end

  def winner
    @winner || self.play!
  end

  def play!
    until @winner do
      if current_player.decision(victim, @last_hit) == :roll
        roll!
      else
        attack!
      end
    end
    @winner
  end

  def roll!
    roll_result = rand(6) + 1
    if roll_result == 1
      current_player.accumulated_damage = 0
      end_turn!
    else
      current_player.accumulated_damage += roll_result
    end
  end

  def end_turn!
    if victim.hit_points <= 0
      @winner = current_player
      # puts "Round Result: #{@winner.class}, #{@winner.hit_points}; #{victim.class}, #{victim.hit_points}"
    else
      @turn_counter += 1
    end
  end

  def attack!
    victim.hit_points -= current_player.accumulated_damage
    @last_hit = current_player.accumulated_damage
    current_player.accumulated_damage = 0
    end_turn!
  end

  def current_player
    @players[@turn_counter % 2]
  end

  def victim
    @players[(@turn_counter + 1 ) % 2]
  end
end

class Player
  attr_accessor :hit_points, :accumulated_damage
  def initialize
    @hit_points = 100
    @accumulated_damage = 0
    @damage_last_turn = 0
    @rolls = 0
  end

  def decision(victim, last_hit)
    if @damage_last_turn >= accumulated_damage
      @rolls = 0
      @damage_last_turn = 0
    end
    @damage_last_turn = accumulated_damage
    @rolls += 1
    if accumulated_damage >= victim.hit_points
      # puts "Default attack"
      :attack
    elsif accumulated_damage == 0
      # puts "Default roll"
      :roll
    else
      # puts "#{self.class} Strategy"
      strategy(victim, last_hit)
    end
  end
end
