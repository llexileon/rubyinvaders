#!/usr/bin/env ruby

require 'gosu'
require './lib/player.rb'
require './lib/projectile.rb'
require './lib/aliens.rb'
require './lib/shields.rb'
require './lib/audioengine'

require 'whenever'

include AudioEngine

module ZOrder
	Background, Actors, Props, UI = *0..3
end

	WIDTH = 1200
	HEIGHT = 900

class GameWindow < Gosu::Window
	def initialize
		super(WIDTH, HEIGHT, false)
		self.caption = 'SPACE INVADERS'
		@font = Gosu::Font.new(self, "assets/victor-pixel.ttf", 40)
		@game_in_progress = false
		@background_image = Gosu::Image.new(self, "assets/background.png", true)
		@life_image = Gosu::Image.new(self, "assets/ship-life.png", false)
		audio_engine
		title_screen
	end

	def title_screen
		@game_in_progress = false
	end

	def setup_game
	    @game_in_progress = true
		@shields = Array.new
		(1..3).to_a.each { |x| @shields.push(Shield.new(self, 300 * x, 675))}

		@player = Player.new(self)
		@player.warp(600, 790)


		@aliens = Array.new
		# Regular GFX #
		(1..10).to_a.each { |x| @aliens.push(Alien.new(self, 100 * x + 50, 200, "ugly")) }
		(1..10).to_a.each { |x| @aliens.push(Alien.new(self, 100 * x + 50, 40, "bad")) }
		(1..10).to_a.each { |x| @aliens.push(Alien.new(self, 100 * x + 50, 120, "good")) }
		# Squib GFX #
		# (1..10).to_a.each { |x| @aliens.push(Alien.new(self, 100 * x + 50, 230, "ugly")) }
		# (1..10).to_a.each { |x| @aliens.push(Alien.new(self, 100 * x + 50, 50, "bad")) }
		# (1..10).to_a.each { |x| @aliens.push(Alien.new(self, 100 * x + 50, 140, "good")) }

		@projectiles = Array.new
		@timer = 0
	end

	def update
		if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
			@player.move_left
		end
		if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
	  		@player.move_right
		end
		return unless @game_in_progress
		detect_collisions
		@timer += 1
		if (@timer % 20) == 0
			@aliens.each {|alien| alien.move}
		end

		if (@timer % 60) == 0
			@aliens.each {|alien| alien.speedy += 0.1 }
		end

		if (@timer % 15) == 0
			invasion unless @aliens == []
		end
		@projectiles.each { |projectile| projectile.move } 
		@projectiles.reject!{|projectile| projectile.inactive?}
	end

	def invasion
		@aliens.sample.shoot(@projectiles)
	end	

	def draw
		@background_image.draw(0,0,ZOrder::Background)
		unless @game_in_progress
	      @font.draw("SPACE INVADERS", 100, 170, 50, 3.0, 3.0, Gosu::Color::GREEN)
	      @font.draw("press 'p' to play", 215, 280, 50, 1, 1, Gosu::Color::rgb(48, 162, 242))
	      @font.draw("press 'q' to quit", 215, 305, 50, 1, 1, Gosu::Color::rgb(48, 162, 242))
	    end
        return unless @game_in_progress
        if @player.lives <= 0
	      @font.draw("GAME OVER", 315, 370, 50, 3.0, 3.0, Gosu::Color::FUCHSIA)
	      @font.draw("press 'm' for menu", 430, 470, 50, 1, 1, Gosu::Color::YELLOW)
	      @font.draw("press 'q' to quit", 430, 495, 50, 1, 1, Gosu::Color::YELLOW)
	    end
		@player.draw unless @player.lives <= 0
		@projectiles.each { |projectile| projectile.draw } 
		@aliens.each { |alien| alien.draw }
		@shields.each { |shield| shield.draw }
		draw_lives
		# Squib GFX
		# @font.draw("score: #{@player.score}", 875, 830, ZOrder::UI, 1.0, 1.0, Gosu::Color::rgb(215,223,32))
		# Regular GFX
		@font.draw("score: #{@player.score}", 875, 830, ZOrder::UI, 1.0, 1.0, Gosu::Color::rgb(0,248,238))
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
	      	@aliens.delete(alien)
	      	# @warp_sample.play unless @player.lives < 0
	      end
	    end      
	    
	    @human_projectiles = @projectiles.select {|p| p.type == "human" }

	    @human_projectiles.each do |projectile|
	        @aliens.each do |alien|
	            if collision?(projectile, alien)
	            	@boom_sample.play(1)#0.6
					@player.score += alien.points
		            @aliens.delete(alien)
		            @projectiles.delete(projectile)
	            end
	        end
	    end

	    @alien_projectiles = @projectiles.select {|p| p.type == "alien" }

	    @alien_projectiles.each do |projectile|
	            if collision?(projectile, @player)
		            @player.kill
		            # @warp_sample.play unless @player.lives < 0
		            @projectiles.delete(projectile)
	            end
	    end

	    @alien_projectiles.each do |alien_projectile|
	    	@human_projectiles.each do |human_projectile|
	    		if collision?(alien_projectile, human_projectile)
		    		@clash_sample.play(0.6)
		    		@player.score += 10
		    		@projectiles.delete(alien_projectile)
		    		@projectiles.delete(human_projectile)
	    		end
	    	end
	    end

	    @alien_projectiles.each do |alien_projectile|
	    	@shields.each do |shield|
	    		if collision?(alien_projectile, shield)
		    		@projectiles.delete(alien_projectile)
		    		hit_shield = shield.impact
		    		@shields << hit_shield unless hit_shield.nil?
		    		@impact_sample.play(1)#(0.6)
		    		@shields.delete(shield)
	    		end
	    	end
	    end

	    # Player shots cant fire through sheilds #
	    # @human_projectiles.each do |human_projectile|
	    # 	@shields.each do |shield|
	    # 		if collision?(human_projectile, shield)
		   #  		@projectiles.delete(human_projectile)
	    # 		end
	    # 	end
	    # end

	end

	def button_down(id)
		close if id == Gosu::KbQ
		if id == Gosu::KbSpace
		    @player.shoot(@projectiles)
		  	@laser_sample.play(1)#(0.5)
		end
		if button_down? Gosu::KbP
        setup_game unless @game_in_progress
        end
    	if button_down? Gosu::KbM
      		title_screen unless @game_in_progress == false
           @game_in_progress = false
        end        
	end

	def draw_lives
	    return unless @player.lives > 0
		    x = 45
		    @player.lives.times do 
		        @life_image.draw(x + 20, 838, ZOrder::UI)
		        x += 30
	        end
        end
    end

window = GameWindow.new
window.show
