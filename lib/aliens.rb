class Alien
	def initialize(window, x, y)
		@x, @y = x, y
		@image = Gosu::Image.new(window, "assets/ship.png")
		@health = 100
		@exploded = false
	end

	def draw
		if @exploded
			#@image.draw_rot(@x, @y, 1, 90.0)
		else
			@image.draw_rot(@x, @y, 1, 180.0)
		end	
	end

	def hit_by(projectiles)
        @exploded = @exploded || projectiles.any? {|projectile| Gosu::distance(projectile.x, projectile.y, @x, @y) < 22}
    end
end