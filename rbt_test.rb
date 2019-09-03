require './rbt'
require 'pp'


t = RedBlackTree.new

t.insert(1, 1)
t.insert(3, 3)
t.insert(2, 2)
t.insert(4, 4)

pp t.dump
pp t.each.to_a

