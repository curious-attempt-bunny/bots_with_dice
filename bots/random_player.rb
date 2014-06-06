class RandomPlayer < Player
  def strategy(victim, last_hit)
    [:roll, :attack].sample
  end
end