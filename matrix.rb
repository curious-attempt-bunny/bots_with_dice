#!/usr/bin/env ruby

require './lib/round'
require './lib/bot'
require './lib/opponents'
require './lib/simulator'

require './my_bot'

wins = Hash.new { |h,k| h[k] = Hash.new }

Opponents.all.each do |bot1|
  Opponents.all.each do |bot2|
  	wins[bot1][bot2] ||= begin
  	  if bot1 == bot2
  	    '-'
  	  else
  	    winner = Simulator.play_out(bot1, bot2, false)
  	    winner.nil? ? '?' : (winner == bot1 ? 'Y' : 'N')
  	  end
  	end
  	wins[bot2][bot1] = wins[bot1][bot2] == 'Y' ? 'N' :(wins[bot1][bot2] == 'N' ? 'Y' : wins[bot1][bot2])
  end
  puts "#{bot1}, #{' ' * ([25 - bot1.name.size, 0].max)} #{wins[bot1].values.join(', ')}"
end