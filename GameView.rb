#
#  GameView.rb
#  CtF
#
#  Created by Thomas R. Koll on 09.12.10.
#  Copyright (c) 2010 ananasblau. All rights reserved.
#

class GameView < NSOpenGLView
	attr_accessor :controller

	def initWithFrame(frame)
		attributes		= Pointer.new_with_type('I', 8)
		attributes[0]	= NSOpenGLPFANoRecovery	
		attributes[1]	= NSOpenGLPFAColorSize
		attributes[2]	= 24
		attributes[3]	= NSOpenGLPFADepthSize
		attributes[4]	= 16
		attributes[5]	= NSOpenGLPFADoubleBuffer
		attributes[6]	= NSOpenGLPFAAccelerated
		attributes[7]	= 0

		pixel_format	= NSOpenGLPixelFormat.alloc.initWithAttributes(attributes)
		initWithFrame(frame, pixelFormat:pixel_format)
		
		return self
	end

	def prepareOpenGL
		glEnable(GL_DEPTH_TEST)
		glEnable(GL_CULL_FACE)
		glEnable(GL_MULTISAMPLE)
		glAlphaFunc ( GL_GREATER, 0.1 )
		glEnable ( GL_ALPHA_TEST )
    glClearColor(0, 0, 0, 0)
	end

	def acceptsFirstResponder
		return true
	end

	def drawRect(rect)
		openGLContext.flushBuffer
	end

	def keyDown(event)
		@controller.keyDown(event)
	end

	def mouseDown(event)
		@controller.mouse_down(event)
	end
end
