class DiscreteJumpBot < Bot
	P = {
		18 => 0.589352885,
		19 => 0.607354493,
		20 => 0.624534834,
		21 => 0.641170771,
		22 => 0.656997422,
		23 => 0.672154305,
		24 => 0.686579784,
		25 => 0.700379099,
		26 => 0.71356938,
		27 => 0.726192718,
		28 => 0.738266612
	}

	JUMP_SIZE = Hash.new do |h, their_hp|
		r = [their_hp - 30, 0].max
		jumps = (18..28).map { |i| [i, (1-P[i]) ** (r/i.to_f).ceil] }
		best = jumps.max { |a,b| a[1] <=> b[1] }
  	
		h[their_hp] = best[0]
	end

  def roll?(our_hp, their_hp, rolls, accumulated_damage)
  	their_hp <= 30 || accumulated_damage  < JUMP_SIZE[their_hp]
  end
end