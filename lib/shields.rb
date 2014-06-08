class Shield

	def initialize(window, x, y, size="large")
		@x, @y = x, y 	
		@image = Gosu::Image.new(window, "assets/shield-#{size}.png")
		@window = window
		@lives = 5
		@size = size
	end

	def hitbox
    hitbox_x = ((@x - @image.width/2).to_i..(@x + @image.width/2.to_i)).to_a
    hitbox_y = ((@y - @image.width/2).to_i..(@y + @image.width/2).to_i).to_a
    {:x => hitbox_x, :y => hitbox_y}
   end

	def draw
		@image.draw_rot(@x, @y, ZOrder::Props, 0)
	end

  def impact
    case @size
      when 'large'
        Shield.new(@window, @x, @y, 'medium')
      when 'medium'
        Shield.new(@window, @x, @y, 'small')
      else
        nil
      end
  end

end
