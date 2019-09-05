require './rbt'
describe RedBlackTree do
  
  def make_tree(seq)
    t = RedBlackTree.new
    seq.each do |n|
      t[n] = n
    end
    t
  end
  
  describe 'empty tree' do
    let(:tree){ RedBlackTree.new }
    
    it '#each returns empty enumrator' do
      expect(tree.each.to_a).to eq([])
    end
    
    it '#[] returns nil' do
      expect(tree[1]).to be_nil
    end
  end

  describe 'insert' do
    let(:t){ RedBlackTree.new }

    it 'insert and get' do
      t[1] = 1
      t[2] = 2
      expect(t[1]).to eq(1)
      expect(t[2]).to eq(2)
      t[1] = 3
      expect(t[1]).to eq(3)
    end
  end

  it 'random check' do
    rand_array = (0..100).to_a.shuffle
    t = RedBlackTree.new
    rand_array.each do |i|
      t[i] = i
    end
    expect(t.each.to_a.map{|x| x[0]}).to eq((0..100).to_a)
    depth = t.depth
    expect(depth[0] * 2 >= depth[1]).to be_truthy
  end

  describe 'delete' do
    it 'delete' do
      t = make_tree([1,2])
      t.delete(1)
      expect(t[1]).to eq(nil)
      expect(t[2]).to eq(2)
    end

    it 'delete' do
      t = make_tree([1,2])
      t.delete(2)
      expect(t[1]).to eq(1)
      expect(t[2]).to eq(nil)
    end

    it 'delete' do
      t = make_tree([1,2,3])
      pp t.dump
      t.delete(2)
      expect(t[1]).to eq(1)
      expect(t[2]).to eq(nil)
    end

    it 'delete random' do
      seq = (0..1000)
      t = make_tree(seq)
      # pp t.dump
      seq.to_a.shuffle.each do |n|
        expect(t[n]).to eq(n)
        t.delete n
        expect(t[n]).to eq(nil)
      end
    end
    
  end

  describe '#range' do
    it '' do
      t = make_tree(0..5)
      expect(t.range(1..2).to_a.size).to eq(2)
      expect(t.range(1...3).to_a.size).to eq(2)
      expect(t.range(4..9).to_a.size).to eq(2)
    end
  end
  
end
