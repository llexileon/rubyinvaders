class Alien
	def initialize(window, x, y, type="good")
		@x, @y = x, y
		@image = Gosu::Image.new(window, "assets/alien-#{type}.png")
		@alive = true
		@exploded = false
	end

	def draw
		if @exploded
			@alive = false
		else
			@image.draw_rot(@x, @y, 1, 180.0)
		end	
	end

	def move!
		@x += dx
		@y += dy

		if @y < 0
			@y = 0
			edge_bounce!
		end

		if @y > Pong::HEIGHT
			@y = Pong::HEIGHT
			edge_bounce!
		end
	end

	def points
	    case @size
	    when 'good'
	      20
	    when 'bad'
	      50
	    when 'ugly'
	      100
	    else
	      0
	    end
	 end          


	def hit_by(projectiles)
        @exploded = @exploded || projectiles.any? {|projectile| Gosu::distance(projectile.x, projectile.y, @x, @y) < 22}
    end
end