require_relative './table_policy_player'

class ContextTablePlayer < TablePolicyPlayer
	P = Hash.new { |h, stops_at| h[stops_at] = Hash.new }

	CSV.foreach("bots/distribution.csv") do |row|
    total, outcome, p = row.map(&:strip)
    P[total.to_i][outcome.to_i] = p.to_f
  end

	STOP_AT = Hash.new do |h, their_hp|
		h[their_hp] = Hash.new do |h, our_hp|
			h[our_hp] = Hash.new do |h, damage|

				options = ([0] + (2..their_hp-damage).to_a).map do |stop_at|
					rating = P[stop_at].map do |stops_at, p|
						if stops_at == 0
							p*(1.0 - WIN_RATE[our_hp][their_hp])
						elsif their_hp - damage - stops_at <= 0
							p*(1.0)
						else
							p*(1.0 - WIN_RATE[our_hp][their_hp - damage - stops_at])
						end
					end.inject(&:+)
					rating = 1.0 - WIN_RATE[our_hp][their_hp-damage] if stop_at == 0
					# puts "#{their_hp} vs #{our_hp} with #{damage} stop_at #{stop_at} & WR #{rating}"
					[stop_at, rating]
				end

				# puts options.inspect 
				best = options.max { |a,b| a[1] <=> b[1] }

				# puts "#{their_hp} vs #{our_hp} stop_at #{damage + best[0]} (#{damage} + #{best[0]})"
				
				h[damage] = best[0] + damage
	    end
		end
	end

	def strategy(victim, last_hit)
		stop_at = STOP_AT[victim.hit_points][hit_points][accumulated_damage]
		policy = POLICY[victim.hit_points][hit_points]
		# puts "BOOM! #{policy} != #{stop_at} for #{victim.hit_points} vs #{hit_points} damage #{accumulated_damage}" if stop_at != policy && !(stop_at == policy + 1 && accumulated_damage + 1 == policy) && accumulated_damage < stop_at
    if accumulated_damage >= stop_at
      :attack
    else
      :roll
    end
  end
end