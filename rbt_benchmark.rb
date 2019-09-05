# frozen_string_literal: true

require 'benchmark'
require './rbt'

# Hashに足りないメソッドを足す
class Hash
  def range(range)
    self.select { |k, _v| range.include?(k) }
  end
end

N = 100_000

puts 'benchamrk add'
Benchmark.bm(20) do |x|
  [Hash, RedBlackTree].each do |cls|
    x.report cls.name do
      t = cls.new
      N.times { |n| t[n] = n }
      N.times { |n| t.delete n }
    end
  end
end

puts
puts 'benchamrk range'
Benchmark.bm(20) do |x|
  [Hash, RedBlackTree].each do |cls|
    t = cls.new
    N.times { |n| t[n] = n }
    x.report cls.name do
      100.times do
        t.range(100...200).to_a
      end
    end
  end
end
