require "pstore"

class WordStore

  def initialize( word )
    @word = word
  end

  attr_reader :word
end
