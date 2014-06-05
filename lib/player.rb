class Player
	attr_reader :x, :y

	def initialize(window)
		@image = Gosu::Image.new(window, "assets/ship.png")
		@last_shot = Time.now
		@window = window
	end

	def warp(x, y)
		@x, @y = x, y
	end

	def move_left
		if @x > 32
			@x -= 5
		end
	end

	def move_right
		if @x < 608
			@x += 5
		end
	end

	def shoot(projectiles)
		if (Time.now - @last_shot) > 0.2
			projectiles.push(Projectile.new(@window, @x-1, @y-20))
			@last_shot = Time.now
		end
	end

	def draw
		@image.draw_rot(@x, @y, 1, 0)
	end
end