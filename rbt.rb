# See: http://wwwa.pikara.ne.jp/okojisan/rb-tree/index.html
class RedBlackTree
  def initialize
    @root = nil
    @changed = false
    @temp_lmax_node = nil
  end

  def [](key)
    find(@root, key)
  end

  def []=(key, value)
    @root = insert(@root, key, value)
    @root.color = :black
  end
  
  def delete(key)
    @root = delete_(@root, key)
    @root&.color = :black
  end

  def each(&block)
    return enum_for(:each) unless block
    
    each_(@root, block) if @root
  end

  def range(range, &block)
    return enum_for(:range, range) unless block
    
    range_(@root, range, block)
  end

  def dump
    @root&.dump
  end
  
  def depth
    if @root
      depth_(@root)
    else
      [0,0]
    end
  end

  private
  
  #===================================================
  
  def find(node, key)
    if node.nil?
      nil
    elsif key == node.key
      node.value
    elsif key < node.key
      find(node.left, key)
    else
      find(node.right, key)
    end
  end

  #===================================================
  
  def find_node(node, key)
    if node.nil?
      nil
    elsif key == node.key
      node
    elsif key < node.key
      find(node.left, key)
    else
      find(node.right, key)
    end
  end
  
  def range_(node, range, block)
    if node.nil?
      return
    else
      if range.begin < node.key
        range_(node.left, range, block)
      end
      if range.include? node.key
        block.call node.key, node.value
      end
      if range.end > node.key
        range_(node.right, range, block)
      end
    end
  end

  #===================================================
  
  def insert(node, key, value)
    if node.nil?
      @changed = true
      Node.new(key, value, :red)
    elsif key == node.key
      node.value = value
      node
    elsif key < node.key
      node.left = insert(node.left, key, value)
      balanced(node)
    else
      node.right = insert(node.right, key, value)
      balanced(node)
    end
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

  #===================================================
  # delete

  def delete_(node, key)
    if node.nil?
      @changed = false
      nil
    elsif key == node.key
      # puts 'del node'
      if node.left.nil?
        @changed = node.black?
        node.right
      else
        node.left = delete_max(node.left)
        node.key = @temp_lmax_node.key
        node.value = @temp_lmax_node.value
        balance_deleted_l(node)
      end
    elsif key < node.key
      # puts 'del l'
      node.left = delete_(node.left, key)
      balance_deleted_l(node)
    else
      # puts 'del r'
      node.right = delete_(node.right, key)
      balance_deleted_r(node)
    end
  end

  def delete_max(node)
    if node.right
      node.right = delete_max(node.right)
      balance_deleted_r(node)
    else
      @temp_lmax_node = node
      @changed = node.black?
      node.left
    end
  end

  def balance_deleted_l(node)
    return node if !@changed
    
    old_col = node.color
    if node.right&.black? && node&.right&.left&.red?
      node = node.rotate_rl
      node.color = old_col
      node.left.color = :black
      @changed = false
    elsif node.right&.black? && node.right&.right&.red?
      node = node.rotate_l
      node.color = old_col
      node.left.color = :black
      node.right.color = :black
      @changed = false
    elsif node.right&.black?
      node.color = :black
      node.right.color = :red
      @changed = (old_col == :black)
    elsif node.right&.red?
      node = node.rotate_l
      node.color = :black
      node.left.color = :red
      node.left = balance_deleted_l(node.left)
      @changed = false
    else
      raise
    end
    
    node
  end

  def balance_deleted_r(node)
    return node if !@changed
    
    old_col = node.color
    if node.left&.black? && node&.left&.right&.red?
      node = node.rotate_lr
      node.color = old_col
      node.right.color = :black
      @changed = false
    elsif node.left&.black? && node.left&.left&.red?
      node = node.rotate_r
      node.color = old_col
      node.left.color = :black
      node.right.color = :black
      @changed = false
    elsif node.left&.black?
      node.color = :black
      node.left.color = :red
      @changed = (old_col == :black)
    elsif node.left&.red?
      node = node.rotate_r
      node.color = :black
      node.right.color = :red
      node.right = balance_deleted_r(node.right)
      @changed = false
    else
      raise
    end
    
    node
  end
  
  #===================================================
    
  def depth_(node)
    return [0,0] unless node
    dl = depth_(node.left)
    dr = depth_(node.right)
    [[dl[0], dr[0]].min + 1, [dl[1], dr[1]].max + 1]
  end

  def each_(node, block)
    each_(node.left, block) if node.left
    block.call [node.key, node.value]
    each_(node.right, block) if node.right
  end

end

class Node
  attr_accessor :key
  attr_accessor :value
  attr_accessor :color
  attr_accessor :right, :left

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
