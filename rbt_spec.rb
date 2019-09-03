require './rbt'
describe RedBlackTree do
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
    end
  end

  it 'random check' do
    rand_array = (0..100).to_a.shuffle
    t = RedBlackTree.new
    rand_array.each do |i|
      t[i] = i
    end
    expect(t.each.to_a.map{|x| x[0]}).to eq((0..100).to_a)
  end
end
