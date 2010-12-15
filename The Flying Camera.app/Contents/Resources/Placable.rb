#
#  Placable.rb
#  VectorFighter
#
#  Created by Thomas R. Koll on 09.12.10.
#  Copyright (c) 2010 Ananasblau. All rights reserved.
#

module Placable
  attr_accessor :x, :y, :z

  def position(x, y, z)
    self.x = x
    self.y = y
    self.z = z
  end

  def orientation
    @orientation ||= 0
  end

  def place
    # Endless screen
    if x > 1 || x < -1 || y > 1 || y < -1
      #self.orientation += rand(90) - 90
    end
    self.x = -1 if x > 1
    self.y = -1 if y > 1
    self.x = 1 if x < -1
    self.y = 1 if y < -1

    glTranslatef(x||0.0, y||0.0, z||0.0)
  end
end
