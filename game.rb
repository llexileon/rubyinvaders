#!/usr/bin/env ruby

require 'gosu'
require './lib/player.rb'
require './lib/projectile.rb'
require './lib/aliens.rb'

module ZOrder
	Background, Actors, UI = *0..2
end

class GameWindow < Gosu::Window
	def initialize
		super(640, 480, false)
		self.caption = 'SPACE INVADERS'

		@background_image = Gosu::Image.new(self, "assets/background.png")
		@life_image = Gosu::Image.new(self, "assets/ship-life.png", false)

		@player = Player.new(self)
		@player.warp(320, 420)

		@aliens = Array.new
		(1..10).to_a.each { |x| @aliens.push(Alien.new(self, 50 * x, 60, "ugly")) }
		(1..10).to_a.each { |x| @aliens.push(Alien.new(self, 50 * x, 120, "bad")) }
		(1..10).to_a.each { |x| @aliens.push(Alien.new(self, 50 * x, 180, "good")) }

		@projectiles = Array.new
	end

	def update
		detect_collisions
		if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
			@player.move_left
		end
		if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
	  		@player.move_right
		end
	    if button_down? Gosu::KbSpace
		  	@player.shoot(@projectiles)
		end

		if button_down? Gosu::KbQ
			close
		end

	  @projectiles.each { |projectile| projectile.move } 

	end

	def draw
		@background_image.draw(0,0,ZOrder::Background)
		@player.draw unless @lives == 0
		@projectiles.each { |projectile| projectile.draw } 
		@aliens.each { |alien| alien.draw }
		draw_lives
	end

	def collision?(object_1, object_2)
	    hitbox_1, hitbox_2 = object_1.hitbox, object_2.hitbox
	    common_x = hitbox_1[:x] & hitbox_2[:x]
	    common_y = hitbox_1[:y] & hitbox_2[:y]
	    common_x.size > 0 && common_y.size > 0 
	end

	def detect_collisions
	  	@aliens.each do |alien|
	      if collision?(alien, @player)
	      	@player.kill
	      	@warp_sample.play unless @player.lives < 0
	      end
	    end  
	    @projectiles.each do |projectile| 
	        @aliens.each do |alien|
	            if collision?(projectile, alien)
		            @player.score += alien.points
		            @aliens.delete(alien)
		            @projectiles.delete(projectile)
	            end
	        end
	    end
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
window = GameWindow.new
window.show
