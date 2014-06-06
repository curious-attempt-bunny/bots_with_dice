#!/usr/bin/env ruby

require './lib/round'
require './lib/bot'
require './lib/opponents'
require './lib/simulator'

require './my_bot'

(Opponents.all - MyBot).each do |opponent|
  Simulator.play_out(MyBot, opponent)
end