# Fullscreen.rb
# The Flying Camera
#
# Created by ben on 11.12.10.
# Copyright 2010 ben. All rights reserved.

class Fullscreen
  attr_accessor	:controller, :fullscreen_context, :active, :before

	def awakeFromNib
		@active	= false
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


		# Create an NSOpenGLContext with the FullScreen pixel format.
		# By specifying the non-FullScreen context as our "shareContext", we automatically inherit...
		# ... all of the textures, display lists, and other OpenGL objects it has defined.
		@fullscreen_context	= NSOpenGLContext.alloc.initWithFormat(pixel_format,
      shareContext:@controller.view.openGLContext)

    puts "Failed to create fullScreenContext" if @fullscreen_context.nil?
    #@controller.game_loop.stop_timer

		# From here, we have to be careful not to lock ourselves in fullscreen mode
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

			@controller.game_loop.set_viewport_rectangle(NSMakeRect(0, 0, w, h))
			# --- EVENT LOOP : ---

			# We are now in fullscreen mode. In this new context, we don't have an event loop like
			# the NSOpenGLView provided, so we have to make our own :

			# --- LEAVING AND CLEANING UP : ---
			# Properly leaving fullscreen mode :

		rescue
			puts "There was a problem while in fullscreen mode !"
		end
    fullscreen_loop
	end

	def fullscreen_loop
    # A flag for wether we have to keep looping or not :
    @active = true

    while @active do
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
			#@controller.game_loop.tick(1/60.0)

      # Render a frame:
      draw_rect
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

		@controller.view.setNeedsDisplay(true)
	end

	def get_event
		event	= NSApp.nextEventMatchingMask(NSAnyEventMask, untilDate:NSDate.distantPast,
                                        inMode:NSDefaultRunLoopMode, dequeue:true)
		return event
	end

	def draw_rect
		@fullscreen_context.flushBuffer
	end
end

