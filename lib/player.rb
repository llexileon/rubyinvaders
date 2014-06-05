class Player
	attr_accessor :x, :y, :angle, :lives, :score

	def initialize(window)
		@image = Gosu::Image.new(window, "assets/ship.png")
		@last_shot = Time.now
		@window = window
		@score = 0
  		@lives = 4
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

	def hitbox
		hitbox_x = ((@x - @image.width/2).to_i..(@x + @image.width/2.to_i)).to_a
		hitbox_y = ((@y - @image.width/2).to_i..(@y + @image.width/2).to_i).to_a
		{:x => hitbox_x, :y => hitbox_y}
	end

	def draw
		@image.draw_rot(@x, @y, 1, 0)
	end

	def draw_lives
	    return unless @player.lives > 0
	    x = 20
	    @player.lives.times do 
	      @life_image.draw(x, 440, 50)
	      x += 20
	  end
    end
end