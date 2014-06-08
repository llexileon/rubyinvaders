class Projectile
	attr_reader :x, :y, :type

	def initialize(window, x, y, type)
		@image = Gosu::Image.new(window, "assets/projectile-#{type}.png")
		@x, @y = x, y
		@type = type
		@distance_traveled, @max_distance = 0, 300
		@active = true
	end

	def draw
		@image.draw(@x, @y, ZOrder::Actors)
	end

	def move
 		if @type == "alien"
 			@y += 2.5
 		end
 		if @type == "human"
 			@y -= 5
 		end
 		@distance_traveled += 1
        kill if @distance_traveled > @max_distance
	end

	def hitbox
    hitbox_x = ((@x - @image.width/2).to_i..(@x + @image.width/2.to_i)).to_a
    hitbox_y = ((@y - @image.width/2).to_i..(@y + @image.width/2).to_i).to_a
    {:x => hitbox_x, :y => hitbox_y}
    end

    def kill
    @active = false
    end

    def inactive?
    !@active
    end
end