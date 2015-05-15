require './onion_ring.rb'
border = OnionRing::run('sample.png', 'output.png')

# borderのleft, top, right, bottomのピクセル数が帰ってくる
p "sample1: #{border}"
p 'success!'
