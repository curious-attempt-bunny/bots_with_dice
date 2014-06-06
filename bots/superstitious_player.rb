class SuperstitiousPlayer < Bot
  def roll?(our_hp, their_hp, rolls, accumulated_damage)
    rolls < 8
  end
end