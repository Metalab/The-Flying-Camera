#
#  GameWindowController.rb
#  CtF
#
#  Created by Thomas R. Koll on 09.12.10.
#  Copyright (c) 2010 ananasblau. All rights reserved.
#

framework 'Cocoa'

class GameWindowController < NSWindowController
	attr_accessor :view, :game_loop, :fullscreen

	def awakeFromNib
    NSSound.soundNamed('Ping').play
		self.game_loop = GameLoop.new(self.view)
	end

  def keyDown(event)
    key = event.characters[0].bytes.to_a[-1]
    if key == 112
      game_loop.stop = !game_loop.stop
      puts game_loop.player.score.score
    end
    if key == 32
      game_loop.stop = true
      if fullscreen.active
        fullscreen.active = false
        fullscreen.exit_fullscreen
        view.active = true
      elsif view.active
        view.active = false
        fullscreen.go_fullscreen
        fullscreen.active true
      end
      game_loop.stop = false
    end
    game_loop.player.keyDown(key)
  end

  def mouse_down(event)
  end
end
