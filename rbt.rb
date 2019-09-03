class RedBlackTree
  def initialize
    @root = nil
  end

  def insert(key, value)
    node = find_node(key, create: true)
    node.value = value
  end

  def find_node(key, create = false)
    if @root
      find_node_(@root, key, create)
    elsif create
      @root = Node.new(key, :black)
      @root
    else
      nil
    end
  end

  def find_node_(node, key, create)
    if key == node.key
      node
    elsif key < node.key
      if node.left
        find_node_(node.left, key, create)
      elsif create
        node.left = Node.new(key, :red)
        node.left
      else
        nil
      end
    else
      if node.right
        find_node_(node.right, key, create)
      elsif create
        node.right = Node.new(key, :red)
        node.right
      else
        nil
      end
    end
  end

  def [](key)
    find_node(key)&.value
  end

  def []=(key, value)
    find_node(key, create: true).value = value
  end
  
  def each(&block)
    return enum_for(:each) unless block
    
    each_(@root, block) if @root
  end

  def each_(node, block)
    each_(node.left, block) if node.left
    block.call [node.key, node.value]
    each_(node.right, block) if node.right
  end

  def dump
    @root&.dump
  end
end

class Node
  attr_reader :key
  attr_reader :color
  
  attr_accessor :right, :left
  attr_accessor :value

  def initialize(key_, color_)
    @key = key_
    @color = color_
  end

  def red?
    @color == :red
  end

  def black?
    @color == :black
  end

  def leaf?
    @left == nil && @right == nil
  end

  def dump
    if @left || @right
      [@color, @key, @left&.dump, @right&.dump]
    else
      @key
    end
  end
end
