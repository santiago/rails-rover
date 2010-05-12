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

  def move(x, y)
    self.update_attributes({:x=>self.x+x.to_i,:y=>self.y+y.to_i})
  end
end
