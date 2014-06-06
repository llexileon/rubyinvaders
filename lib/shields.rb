class Shield

	def initialize(window, x, y)
	@x, @y = x, y 	
	@image = Gosu::Image.new(window, "assets/shield.png")
	@window = window
	@lives = 5
	end

	def draw
		@image.draw_rot(@x, @y, 1, 0)
	end
end
