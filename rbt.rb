class RedBlackTree
  def initialize
    @root = nil
    @changed = false
  end

  def find(key)
    if @root
      find_(@root, key)
    else
      nil
    end
  end

  def find_(node, key)
    if key == node.key
      node
    elsif key < node.key
      node.left && find_(node.left, key)
    else
      node.right && find_(node.right, key)
    end
  end

  def insert(key, value)
    if @root
      @root = insert_(@root, key, value)
    else
      @root = Node.new(key, value, :black)
    end
    @root.color = :black
  end

  def insert_(node, key, value)
    if node.nil?
      @changed = true
      Node.new(key, value, :red)
    elsif key == node.key
      node.value = value
      node
    elsif key < node.key
      node.left = insert_(node.left, key, value)
      balanced(node)
    else
      node.right = insert_(node.right, key, value)
      balanced(node)
    end
  end

  def depth
    if @root
      depth_(@root)
    else
      [0,0]
    end
  end

  def depth_(node)
    return [0,0] unless node
    dl = depth_(node.left)
    dr = depth_(node.right)
    [[dl[0], dr[0]].min + 1, [dl[1], dr[1]].max + 1]
  end

  def balanced(node)
    return node if !@changed || !node.black?
      
    if node.left&.red? && node.left&.left&.red?
      # puts 'r'
      node = node.rotate_r
      node.left.color = :black
    elsif node.left&.red? && node.left&.right&.red?
      # puts 'lr'
      node = node.rotate_lr
      node.left.color = :black
    elsif node.right&.red? && node.right&.left&.red?
      # puts 'rl'
      node = node.rotate_rl
      node.right.color = :black
    elsif node.right&.red? && node.right&.right&.red?
      # puts 'l'
      node = node.rotate_l
      node.right.color = :black
    else
      @changed = false
    end
    node
  end

  def [](key)
    find(key)&.value
  end

  def []=(key, value)
    insert(key, value)
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
  
  attr_accessor :color
  attr_accessor :right, :left
  attr_accessor :value

  def initialize(key_, value_, color_)
    @key = key_
    @value = value_
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

  def rotate_l
    u = @right
    t2 = u.left
    u.left = self
    self.right = t2
    u
  end

  def rotate_r
    v = @left
    t2 = v.right
    v.right = self
    self.left = t2
    v
  end

  def rotate_lr
    @left = @left.rotate_l
    rotate_r
  end

  def rotate_rl
    @right = @right.rotate_r
    rotate_l
  end
  
end
