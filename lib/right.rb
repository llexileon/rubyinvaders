class RightBarrier
 	attr_accessor :x, :y, :angle

 	def initialize(window)
 		@image = Gosu::Image.new(window, "assets/barrier.png")
	 	@x, @y, @angle = 640, 300, 0
 	end

	def hitbox
		hitbox_x = ((@x - @image.width/2).to_i..(@x + @image.width/2.to_i)).to_a
		hitbox_y = ((@y - @image.height/2).to_i..(@y + @image.height/2).to_i).to_a
		{:x => hitbox_x, :y => hitbox_y}
	end	

	def draw
		@image.draw_rot(@x, @y, 1, @angle)
	end
end
