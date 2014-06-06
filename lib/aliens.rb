class Alien
	def initialize(window, x, y, type="good")
		@x, @y, @angle = x, y, 90
		@image = Gosu::Image.new(window, "assets/alien-#{type}.png")
		@speed_modifier = 0.5
		@window = window
		@last_shot = Time.now + rand(20)
	end

	def draw
		@image.draw_rot(@x, @y, 1, 180.0)
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

	def move
	    @x += @speed_modifier*Math.sin(Math::PI/180*@angle)
	    @y += -@speed_modifier*Math.cos(Math::PI/180*@angle)
	end
	
	def shoot(projectiles)
		if (Time.now - @last_shot) > 5
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