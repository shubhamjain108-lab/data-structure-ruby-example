require 'pstore'
require_relative 'word'

class Trie
  
  attr_accessor :root, :children, :isEndOfWord

  def initialize
    @children = []
    @isEndOfWord = false
  end  

  def insert(key)
    p = @root
    for level in 0..key.length-1
      index = key[level].ord - "a".ord
      if p.children[index] == nil
        p.children[index] = Trie.new
      end
      p = p.children[index]
    end
    p.isEndOfWord = true
  end

  def search(key)
    index = 0
    level = 0
    length = key.length
    p = @root
    for level in 0..length-1
      index = key[level].ord - "a".ord
      if p.children[index] == nil
        return false
      end
      p = p.children[index]
    end
    return (p != nil && p.isEndOfWord)
  end

  def test_trie
    keys = ["a", "the", "they", "any"]
    outputs = ["present in trie", "Not present in trie"]
    @root = Trie.new
    store = PStore.new("word.pstore")
    #File.open('word.ser', 'w+') do |f|
      for i in 0..keys.length-1
        #puts "#{f}"  
        #f.write Marshal.dump(keys[i])
        word = WordStore.new(keys[i])
        store.transaction do
          store[word] = keys[i]
        end
        insert(keys[i])
      end  
    #end

    if (search("an") == true)
      puts "#{outputs[0]}"
    else
      puts "#{outputs[1]}"  
    end

    #File.open('word.ser', 'r') do |f|  
    #  @gc = Marshal.load(f)
    #  puts "#{@gc}"  
    #end

    store.transaction(true) do
      store.roots.each do |word|
        puts "#{store[word]}"
      end
    end
  end
end

Trie.new.test_trie