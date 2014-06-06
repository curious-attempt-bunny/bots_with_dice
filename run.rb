#!/usr/bin/env ruby

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

class Bot < Player
  def strategy(victim, last_hit)
    roll?(hit_points, victim.hit_points, @rolls, accumulated_damage) ? :roll : :attack
  end
end

require './my_bot'

MAX_ROUNDS = 1000000 # Rounds are matched pairs - P1 first, then P2 first
MIN_ROUNDS = 1000

  def camelize(term, uppercase_first_letter = true)
      string = term.to_s
      "_#{string}".gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
    end

opponents = Dir.glob('bots/*.rb').map do |bot|
  require File.expand_path(bot)
  eval(camelize(File.basename(bot).sub(%r{\.rb$}, '')))
end

# http://en.wikipedia.org/wiki/Checking_whether_a_coin_is_fair
Z = 3.2905 # 99.9% confidence
E = Hash.new { |h,k| h[k] = Z/(2*Math.sqrt(k)) }

SPINNY = ['-','/','|','\\'].reverse

opponents.each do |opponent|
  match_pair = [MyBot, opponent]
  print "VS #{opponent} -"
results = Hash.new(0)
  n = 0
  MAX_ROUNDS.times do
    results[Round.new(match_pair.map(&:new)).winner.class] += 1
    results[Round.new(match_pair.reverse.map(&:new)).winner.class] += 1

    n += 2
    margin = (results[match_pair[0]] - results[match_pair[1]]).abs / n.to_f
    if n % 10000 == 0
      if ENV['DEBUG'] == 'true'
        puts "n: #{n}, E:#{E[n]}, margin: #{margin}"
      else
        print "\x08#{SPINNY[(n / 10000)%SPINNY.size]}"
      end
    end
    break if n >= MIN_ROUNDS && margin >= 2*E[n]
  end

  print "\x08"

  if results[MyBot] >= results[opponent]
    puts "WINS"
  else
    puts "LOSES"
  end
end