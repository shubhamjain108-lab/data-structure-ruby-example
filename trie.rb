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
    p = @root
    for level in 0..key.length-1
      index = key[level].ord - "a".ord
      if p.children[index] == nil
        return false
      end
      p = p.children[index]
    end
    return (p != nil && p.isEndOfWord)
  end

  def test_trie
    words = []
    i = 0
    keys = ["a", "the", "they", "any"]
    outputs = ["present in trie", "Not present in trie"]
    @root = Trie.new
    store = PStore.new('E:\ruby\data-structure-ruby-example\data\word.pstore')
    store.transaction(true) do
      store.roots.each do |word|
        words[i] = store[word]
        words = words.uniq
        puts "#{words}"
        i += 1
      end
    end
    for i in 0..keys.length-1
      word = WordStore.new(keys[i])
      store.transaction do
        store[word] = keys[i]
      end
      insert(keys[i])
    end  
    
    if (search("an") == true)
      puts "#{outputs[0]}"
    else
      puts "#{outputs[1]}"  
    end
  end
end

Trie.new.test_trie