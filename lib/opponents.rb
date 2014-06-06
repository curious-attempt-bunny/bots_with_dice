module Opponents
  def self.all
    Dir.glob('bots/*.rb').map do |bot|
      require File.expand_path(bot)
      eval(camelize(File.basename(bot).sub(%r{\.rb$}, '')))
    end
  end

  private

  def self.camelize(term, uppercase_first_letter = true)
    string = term.to_s
    "_#{string}".gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
  end
end