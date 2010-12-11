# Fullscreen.rb
# The Flying Camera
#
# Created by ben on 11.12.10.
# Copyright 2010 ben. All rights reserved.

class Fullscreen
  attr_accessor	:controller, :fullscreen_context, :stay_in_fullscreen_mode, :before

	def awakeFromNib
		@stay_in_fullscreen_mode	= false
	end

	def go_fullscreen
		main_display_id		= CGMainDisplayID()

		# Pixel Format Attributes for the FullScreen NSOpenGLContext:
		attributes			= Pointer.new_with_type('I', 11)
		attributes[0]		= NSOpenGLPFANoRecovery

    # Specify that we want a full-screen OpenGL context
		attributes[1]		= NSOpenGLPFAFullScreen

    # We may be on a multi-display system (and each screen may be driven by a different renderer)...
		attributes[2]		= NSOpenGLPFAScreenMask

    #... so we need to specify which screen we want to take over.  For this demo, we'll specify...
    #... the main screen.
		attributes[3]		= CGDisplayIDToOpenGLDisplayMask(main_display_id)
		attributes[4]		= NSOpenGLPFAColorSize
		attributes[5]		= 24
		attributes[6]		= NSOpenGLPFADepthSize
		attributes[7]		= 16
		attributes[8]		= NSOpenGLPFADoubleBuffer
		attributes[9]		= NSOpenGLPFAAccelerated
		attributes[10]		= 0

		# Create the FullScreen NSOpenGLContext with the attributes listed above :
		pixel_format		= NSOpenGLPixelFormat.alloc.initWithAttributes(attributes)

		# Just as a diagnostic, report the renderer ID that this pixel format binds to.
		# CGLRenderers.h contains a list of known renderers and their corresponding RendererID codes.
		renderer_id			= Pointer.new_with_type('i')
		pixel_format.getValues(renderer_id, forAttribute:NSOpenGLPFARendererID, forVirtualScreen:0)
		puts "NSOpenGLView pixelFormat RendererID = %08x" % renderer_id[0]

		# Create an NSOpenGLContext with the FullScreen pixel format.
		# By specifying the non-FullScreen context as our "shareContext", we automatically inherit...
		# ... all of the textures, display lists, and other OpenGL objects it has defined.
		@fullscreen_context	= NSOpenGLContext.alloc.initWithFormat(pixel_format,
                                                              shareContext:@controller.opengl_view.openGLContext)

    puts "Failed to create fullScreenContext" if @fullscreen_context.nil?

		# Pause animation in the OpenGL view.  While we're in full-screen mode, we'll have to...
		# ... drive the animation actively instead of using a timer callback.
		@controller.stop_animation_timer if @controller.animating

		# From here, we have to be carefull not to lock ourselves in fullscreen mode
		begin
			# --- SET UP AFTER THE MAIN DISPLAY WAS CAPTURED : --- 
			# Take control of the main display where we're about to go fullscreen
			error				= CGDisplayCapture(main_display_id)

			return if error != CGDisplayNoErr

			# Enter FullScreen mode and make our FullScreen context the active context for OpenGL commands :
			@fullscreen_context.setFullScreen
			@fullscreen_context.makeCurrentContext

			# Save the current swap interval so we can restore it later, and then ...
			# ... set the new swap interval to lock us to the display's refresh rate
			@old_swap_interval	= Pointer.new_with_type('i')
			new_swap_interval	= Pointer.new_with_type('i')
			new_swap_interval[0]= 1								# set to 1, so vbl sync is active

			@cgl_context		= CGLGetCurrentContext()

			CGLGetParameter(@cgl_context, KCGLCPSwapInterval, @old_swap_interval)
			CGLSetParameter(@cgl_context, KCGLCPSwapInterval, new_swap_interval)

			# Tell the scene the dimensions of the area it's going to render to, ...
			# ... so it can set up an appropriate viewport and viewing transformation
			w					= CGDisplayPixelsWide(main_display_id)
			h					= CGDisplayPixelsHigh(main_display_id)

			@controller.scene.set_viewport_rectangle(NSMakeRect(0, 0, w, h))
			# --- EVENT LOOP : ---

			# We are now in fullscreen mode. In this new context, we don't have an event loop like ...
			# ... the NSOpenGLView provided, so we have to make our own :
			fullscreen_loop

			# --- LEAVING AND CLEANING UP : ---
			# Properly leaving fullscreen mode :
			exit_fullscreen

		rescue
			puts "There was a problem while in fullscreen mode !"
		end
	end

	def fullscreen_loop
			# A flag for wether we have to keep looping or not :
			@stay_in_fullscreen_mode	= true

			# Used to keep track of each loop iteration's duration :
      @before = CFAbsoluteTimeGetCurrent()
			now     = 0

			while @stay_in_fullscreen_mode do
				while (event = get_event) do
					case event.type
					when NSLeftMouseDown
						@controller.mouseDown(event)

					when NSLeftMouseUp
						@controller.mouseUp(event)

					when NSLeftMouseDragged
						@controller.mouseDragged(event)

					when NSKeyDown
						@controller.keyDown(event)
					end
				end
				event = nil

				# Update our animation:
				now			= CFAbsoluteTimeGetCurrent()
				@controller.scene.advance_time_by(now - @before) if @controller.animating
				@before = now

				# Render a frame:
				draw_rect

				# Quick note : at first glance, it looks like this loop will try to redraw frames
				# without any proper timing, so much to often. But remember vbl syncronization
				# is enabled, so each call to draw_rect and therefore to flushBuffer introduces
				# a "natural" delay , ensuring that we don't refresh faster than the screen's
				# refresh rate.
			end
	end

	def exit_fullscreen
		# Restore the previously set swap interval :
		CGLSetParameter(@cgl_context, KCGLCPSwapInterval, @old_swap_interval)

		# Exit fullscreen mode and release our FullScreen NSOpenGLContext :
		NSOpenGLContext.clearCurrentContext
		@fullscreen_context.clearDrawable

		# Release control of the display :
		CGReleaseAllDisplays()

		# Mark our view as needing drawing.
    # (The animation has advanced while we were in FullScreen mode, so its current contents are stale.)
		@controller.opengl_view.setNeedsDisplay(true)

		# Resume animation timer firings :
		@controller.start_animation_timer if @controller.animating
	end

	def get_event
		event	= NSApp.nextEventMatchingMask(NSAnyEventMask, untilDate:NSDate.distantPast,
                                        inMode:NSDefaultRunLoopMode, dequeue:true)
		return event
	end

	def draw_rect
		@controller.scene.render
		@fullscreen_context.flushBuffer
	end
end

