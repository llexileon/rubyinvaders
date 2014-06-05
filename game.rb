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

		@player = Player.new(self)
		@player.warp(320, 420)

		@aliens = Array.new
		(1..5).to_a.each { |x| @aliens.push(Alien.new(self, 105 * x, 60)) }

		@projectiles = Array.new
	end

	def update
		if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
			@player.move_left
		end
		if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
	  	@player.move_right
	  end
	  if button_down? Gosu::KbSpace
	  	@player.shoot(@projectiles)
	  end

	  @projectiles.each { |projectile| projectile.move }
	  @aliens.each { |alien| alien.hit_by(@projectiles) }

	end

	def draw
		@background_image.draw(0,0,ZOrder::Background)
		@player.draw
		@projectiles.each { |projectile| projectile.draw }
		@aliens.each { |alien| alien.draw }
	end
end

window = GameWindow.new
window.show
