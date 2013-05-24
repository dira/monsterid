require 'oily_png'
require 'digest'
require 'base64'

module MonsterId

  class Monster
    SIZE = 120

    def initialize(seed, size=nil)
      srand Digest::MD5.hexdigest(seed.to_s).to_i(16)

      # throw the dice for body parts
      parts = {
        legs:  rand(5),
        hair:  rand(5),
        arms:  rand(5),
        body:  rand(15),
        eyes:  rand(15),
        mouth: rand(10),
      }

      @image = ChunkyPNG::Image.new SIZE, SIZE, ChunkyPNG::Color::TRANSPARENT

      parts.each do |name, number|
        path = File.join File.dirname(__FILE__), 'parts', "#{name}_#{number + 1}.png"
        part = ChunkyPNG::Image.from_file path

        if name == :body
          # random body color
          w, h = part.width, part.height
          r, g, b = rand(215) + 20, rand(215) + 20, rand(215) + 20
          body_color = r * 256 * 256 * 256 + g * 256 * 256 + b * 256 + 255
          part.pixels.each_with_index do |color, i|
            unless color == 0 || color == 255
              part[i % w, (i / w).to_i] = body_color
            end
          end
        end

        @image.compose!(part, 0, 0)
      end

      @image.resample_bilinear!(size, size) unless size == nil or size == SIZE

      srand
    end

    def to_s
      @image.to_datastream.to_s
    end

    def inspect
      ''
    end

    def to_data_uri
      'data:image/png;base64,' + Base64.encode64(@image.to_s).gsub(/\n/, '')
    end

    def save(path)
      @image.save(path)
    end
  end

end
