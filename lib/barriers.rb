class Barrier
 	attr_accessor :side, :x, :y, :angle

 	def initialize(window, side)
 		@image = Gosu::Image.new(window, "assets/barrier.png")
 		@side = side
 		if side == "left"
	 			@x, @y, @angle = 1, 300, 90
	 	end
	 	if side == "right"
	 			@x, @y, @angle = 640, 300, 90
 		end
 	end

	def hitbox
		hitbox_x = ((@x - @image.width/2).to_i..(@x + @image.width/2.to_i)).to_a
		hitbox_y = ((@y - @image.width/2).to_i..(@y + @image.width/2).to_i).to_a
		{:x => hitbox_x, :y => hitbox_y}
	end	

	def draw
		@image.draw_rot(@x, @y, 1, 90)
	end
end
