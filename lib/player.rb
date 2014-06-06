class Player
	attr_accessor :x, :y, :angle, :lives, :score

	def initialize(window)
		@image = Gosu::Image.new(window, "assets/ship.png")
		@last_shot = Time.now
		@window = window
		@score = 0
  		@lives = 5
	end

	def warp(x, y)
		@x, @y = x, y
	end

	def move_left
		if @x > 80
			@x -= 5
		end
	end

	def move_right
		if @x < 1120
			@x += 5
		end
	end

	def shoot(projectiles)
		if (Time.now - @last_shot) > 0.5
			projectiles.push(Projectile.new(@window, @x-4, @y-40, "human"))
			@last_shot = Time.now
		end
	end

	def hitbox
		hitbox_x = ((@x - @image.width/2).to_i..(@x + @image.width/2.to_i)).to_a
		hitbox_y = ((@y - @image.width/2).to_i..(@y + @image.width/2).to_i).to_a
		{:x => hitbox_x, :y => hitbox_y}
	end

	def draw
		@image.draw_rot(@x, @y, 1, 0)
	end

	  def kill
		@lives -= 1	
		alive = false
		return if lives <= 0
	end

end