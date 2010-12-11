#
#  GameWindowController.rb
#  CtF
#
#  Created by Thomas R. Koll on 09.12.10.
#  Copyright (c) 2010 ananasblau. All rights reserved.
#

framework 'Cocoa'

class GameWindowController# < NSWindowController
	attr_accessor :view, :game_loop, :fullscreen

	def awakeFromNib
		self.game_loop = GameLoop.new(self.view)
	end

  def go_fullscreen(sender)
		@fullscreen.go_fullscreen
	end

  def keyDown(event)
    puts @fullscreen.inspect
    key = event.characters[0].bytes.to_a[-1]
    game_loop.stop = !game_loop.stop if key == 112
    game_loop.player.keyDown(key)
  end

  def mouse_down(event)
    #puts event.inspect
  end
end
