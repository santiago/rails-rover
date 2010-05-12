class Rover < ActiveRecord::Base
  validates_uniqueness_of :label,
                          :message => "Label for rover already taken"

  validates_numericality_of :x, :only_integer => true
  validates_numericality_of :y, :only_integer => true
  validates_inclusion_of :x, 
                         :in => 0..19, 
                         :message => "I can't reach that position"
  validates_inclusion_of :y, 
                         :in => 0..19, 
                         :message => "I can't reach that position"

  def move_1d(direction, distance)
    self.x= self.x+distance if direction == "x"
    self.y= self.y+distance if direction == "y"
    self.save!
  end

  def move_2d(distance_x, distance_y)
    self.x= x
    self.y= y
    self.save!
  end
end
