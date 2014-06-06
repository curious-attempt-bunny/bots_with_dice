#!/usr/bin/env ruby

require './lib/round'
require './lib/bot'
require './lib/opponents'
require './lib/simulator'

require './my_bot'

require 'csv'

def opposite(result)
	result == 'Y' ? 'N' : (result == 'N' ? 'Y' : result)
end

wins = Hash.new { |h,k| h[k] = Hash.new }

opponents_by_digest = Hash[Opponents.all.map { |opponent| [opponent.digest, opponent] }]
CSV.foreach('./mappings.txt') do |row|
	digest1, digest2, result = row.map(&:strip)
	bot1 = opponents_by_digest[digest1]
	bot2 = opponents_by_digest[digest2]
	wins[bot1][bot2] = result if bot1 && bot2
	wins[bot2][bot1] = opposite(result) if bot1 && bot2
end

def record_result(wins, bot1, bot2, result)
	wins[bot1][bot2] = result
	wins[bot2][bot1] = opposite(result)
	File.open('./mappings.txt', 'a+') do |f|
		f.puts "#{bot1.digest}, #{bot2.digest}, #{result}"
	end
end

Opponents.all.each do |bot1|
  Opponents.all.each do |bot2|
  	unless wins[bot1][bot2]
	  	result = begin
	  	  if bot1 == bot2
	  	    '-'
	  	  else
	  	    winner = Simulator.play_out(bot1, bot2)
	  	    winner.nil? ? '?' : (winner == bot1 ? 'Y' : 'N')
	  	  end
	  	end
	  	record_result(wins, bot1, bot2, result)
	  end
  end
end

ranked_opponents = Opponents.all.sort { |a,b| wins[b].values.select { |x| x == 'Y' }.size <=> wins[a].values.select { |x| x == 'Y' }.size }
ranked_opponents.each_with_index do |bot, i|
  puts "#{i+1 < 10 ? ' ' : ''}#{i+1}: #{bot}, #{' ' * ([25 - bot.name.size, 0].max)} #{ranked_opponents.map { |opponent| wins[bot][opponent] }.join(', ')}"
end