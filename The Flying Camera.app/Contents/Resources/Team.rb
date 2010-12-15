#
#  Team.rb
#  CtF
#
#  Created by Thomas R. Koll on 10.12.10.
#  Copyright (c) 2010 ananasblau. All rights reserved.
#
require 'team'
class Team
  attr_accessor :planes, :name, :colour

  def initialize(name, colour = [0,0,0], number_of_planes = 0)
    self.name = name
    self.colour = colour
    self.planes ||= []
    number_of_planes.times do
      self.planes << Enemy.new(self)
    end
  end
end
