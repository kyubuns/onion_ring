require '../onion_ring.rb'
border = OnionRing::run('source.png', 'output.png')

# borderのleft, top, right, bottomのピクセル数が帰ってくる
p "border: #{border}"
p 'success!'
