require 'oily_png'
require 'digest/sha1'

module OnionRing
  def self.run(source_file_name, output_file_name = nil)
    output_file_name = source_file_name unless output_file_name

    png = ChunkyPNG::Image.from_file(source_file_name)
    range_width  = OnionRing::calc_trim_range((0...png.width).map{|x| Digest::SHA1.hexdigest(png.column(x).join{|a| a.to_s}) })
    range_height = OnionRing::calc_trim_range((0...png.height).map{|y| Digest::SHA1.hexdigest(png.row(y).join{|a| a.to_s}) })

    dpix = 2
    if range_width == nil or range_width[1] - range_width[0] <= dpix*2
      range_width = [0, -1]
    else
      range_width[0] += dpix
      range_width[1] -= dpix
    end

    if range_height == nil or range_height[1] - range_height[0] <= dpix*2
      range_height = [0, -1]
    else
      range_height[0] += dpix
      range_height[1] -= dpix
    end

    OnionRing::create_sliced_image(png, output_file_name, range_width, range_height)

    # left, top, right, bottom
    range_width = [1, png.width - dpix] if range_width == [0, -1]
    range_height = [1, png.height - dpix] if range_height == [0, -1]
    left = range_width[0] - 1
    top = range_height[0] - 1
    right = png.width - range_width[1] - dpix
    bottom = png.height - range_height[1] - dpix

    [left, top, right, bottom]
  end

  def self.calc_trim_range(hash_list)
    tmp_hash = nil
    tmp_start_index = 0
    max_length = 0
    max_range = nil
    hash_list.each_with_index do |hash, index|
      length = ((index - 1) - tmp_start_index)
      if length > max_length
        max_length = length
        max_range = [tmp_start_index, index - 1]
      end

      if tmp_hash != hash
        tmp_hash = hash
        tmp_start_index = index
      end
    end
    max_range
  end

  def self.create_sliced_image(png, output_file_name, range_width, range_height)
    output_width = png.width - ((range_width[1] - range_width[0]) + 1)
    output_height = png.height - ((range_height[1] - range_height[0]) + 1)

    output = ChunkyPNG::Image.new(output_width, output_height, ChunkyPNG::Color::TRANSPARENT)
    (0...output_width).each do |ax|
      (0...output_height).each do |ay|
        bx = ax
        by = ay
        bx = ax + ((range_width[1] - range_width[0]) + 1) if bx >= range_width[0]
        by = ay + ((range_height[1] - range_height[0]) + 1) if by >= range_height[0]
        output[ax, ay] = png.get_pixel(bx, by)
      end
    end
    output.save(output_file_name)
  end
end
