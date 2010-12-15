#
#  Visibility.rb
#  The Flying Camera
#
#  Created by Thomas R. Koll on 11.12.10.
#  Copyright (c) 2010 ananasblau. All rights reserved.
#

module Visibility
  attr_accessor :view_width
  # Array with two (for 2D) values
  attr_accessor :view_angle

  def objects_in_view(objects)
    if view_angle.nil? || view_angle.empty? || view_angle.size != 2
      raise 'Missing view angle for %s' % self
    end
    return objects.collect do |object|
      # nur im Rückschritt liegt die Zukunft
      a = self.x - object.x
      b = self.y - object.y

      gamma = Math.atan2(b,a)
      gamma = ((gamma / Math::PI * 180) + 180) % 360

      n = view_angle[0]
      m = view_angle[1]
      if (m < n && gamma > m && gamma < n) || (m > n && (gamma > m || gamma < n))
        [object, gamma, Math.sqrt(a**2 + b**2)]
      else
        nil
      end
    end.compact
  end
end
