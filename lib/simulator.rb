module Simulator
  MAX_ROUNDS = 1000000 # Rounds are matched pairs - P1 first, then P2 first
  MIN_ROUNDS = 1000

  # http://en.wikipedia.org/wiki/Checking_whether_a_coin_is_fair
  Z = 3.2905 # 99.9% confidence
  E = Hash.new { |h,k| h[k] = Z/(2*Math.sqrt(k)) }

  SPINNY = ['-','/','|','\\'].reverse

  def self.play_out(bot1, bot2, verbose = true)
    match_pair = [bot1, bot2]
    print "#{bot1} VS #{bot2}#{' ' * ([25 - bot2.name.size, 0].max)}  " if verbose
    results = Hash.new(0)
    n = 0
    MAX_ROUNDS.times do
      results[Round.new(match_pair.map(&:new)).winner.class] += 1
      results[Round.new(match_pair.reverse.map(&:new)).winner.class] += 1
  
      n += 2
      margin = (results[match_pair[0]] - results[match_pair[1]]).abs / n.to_f
      if n % 10000 == 0
        if ENV['DEBUG'] == 'true'
          puts "n: #{n}, E:#{E[n]}, margin: #{margin}" if verbose
        else
          print "\x08#{SPINNY[(n / 10000)%SPINNY.size]}" if verbose
        end
      end
      break if n >= MIN_ROUNDS && margin >= 2*E[n]
    end
  
    if verbose
      print "\x08"
    
      if results[bot1] >= results[bot2]
        puts "WINS" 
      else
        puts "LOSES"
      end
    end
  end
end