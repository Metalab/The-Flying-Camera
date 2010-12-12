#
#  GameLoop.rb
#  CtF
#
#  Created by Thomas R. Koll on 09.12.10.
#  Copyright (c) 2010 ananasblau. All rights reserved.
#

class GameLoop
  attr_accessor :view, :timer, :player, :elements, :scene, :teams, :stop

  def initialize(view)
    self.view = view
    self.scene = Scene.new
    self.teams = [
      Team.new('Kaiserliche Fliegertruppe', [0.8, 0.8, 0.8], 2),
      Team.new('Royal Flying Corps', [0.6, 0.62, 0.6], 2)
    ]
    self.elements ||= self.teams.collect(&:planes).flatten

    self.player = Player.new
    start_timer
  end

  def start_timer
    timer ||= NSTimer.scheduledTimerWithTimeInterval( 1/60.0,
            target:self, selector:"timer_fired:",
            userInfo:nil, repeats:true)
  end

  def timer_fired(timer)
    tick(1/60.0)
    if view.active
      view.openGLContext.flushBuffer
      view.setNeedsDisplay true
    end
  end

  def tick(seconds)
    return if self.stop
    scene.redraw(seconds)

    player.redraw(seconds)
    elements.map do |e|
      e.find_target(elements.reject {|e1| e1.team == e.team})
      e.redraw(seconds)
    end
    player.make_picture(elements)
  end

	def stop_timer
		if @timer != nil then
			@timer.invalidate
			@timer = nil
		end
	end
  
  
	def set_viewport_rectangle(bounds)
  return
  	glViewport(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height)

		glMatrixMode(GL_PROJECTION)
		glLoadIdentity
		gluPerspective(30, bounds.size.width / bounds.size.height, 1.0, 1000.0)
	end
end
