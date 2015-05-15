require '../onion_ring.rb'
border = OnionRing::run('before.png', 'after.png')

# borderのleft, top, right, bottomのピクセル数が帰ってくる
p "border: #{border}"
p 'success!'
