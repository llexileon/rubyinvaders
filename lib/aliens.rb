class Alien
	attr_accessor :speedy

	def initialize(window, x, y, type="good")
		@x, @y, @start_x, @start_y, @angle = x, y, x, y, 180
		@direction = :left
		@image = Gosu::Image.new(window, "assets/alien-#{type}.png")
		@window = window
		@last_shot = Time.now + rand(15)
		@type = type
		@speedy = 10
	end

	def draw
		@image.draw_rot(@x, @y, ZOrder::Actors, 0)
	end

	def points
	    case @type
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

	def move
		move_left if @direction == :left
		move_right if @direction == :right
	end

	def move_left
		if (@x - @start_x) < 80
	    	@x += @speedy 
	    else
	    	change_direction
	    end
	end

	def move_right
		if (@start_x - @x) < 80
	    	@x -= @speedy
	    else
	    	change_direction
	    end
	end

	def change_direction
		@y += @speedy
		@direction = (@direction == :left) ? :right : :left
	end
	
	def shoot(projectiles)
		if (Time.now - @last_shot) > 4
			projectiles.push(Projectile.new(@window, @x-1, @y+60, "alien"))
			@last_shot = Time.now
		end
	end

	def hitbox
        hitbox_x = ((@x - @image.width/2).to_i..(@x + @image.width/2.to_i)).to_a
  		hitbox_y = ((@y - @image.width/2).to_i..(@y + @image.width/2).to_i).to_a
  		{:x => hitbox_x, :y => hitbox_y}
  	end 
end