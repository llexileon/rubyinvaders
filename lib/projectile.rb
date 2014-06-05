class Projectile
	attr_reader :x, :y

	def initialize(window, x, y)
		@image = Gosu::Image.new(window, "./assets/projectile.png")
		@x, @y = x, y
	end

	def draw
		@image.draw(@x, @y, ZOrder::Actors, 1, 1, 0xffffffff, :add)
	end

	def move
		@y -= 5
	end
end