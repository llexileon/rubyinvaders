class Projectile
	attr_reader :x, :y, :type

	def initialize(window, x, y, type)
		@image = Gosu::Image.new(window, "./assets/projectile.png")
		@x, @y = x, y
		@angle = 180
		@type = type
	end

	def draw
		@image.draw(@x, @y, @angle)
	end

	def move
		@y -= 5
	end

	def hitbox
    hitbox_x = ((@x - @image.width/2).to_i..(@x + @image.width/2.to_i)).to_a
    hitbox_y = ((@y - @image.width/2).to_i..(@y + @image.width/2).to_i).to_a
    {:x => hitbox_x, :y => hitbox_y}
    end

end