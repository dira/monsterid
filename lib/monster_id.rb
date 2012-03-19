require "monster_id/version"
require "monster_id/monster"

##
# A Ruby port of http://www.splitbrain.org/projects/monsterid
module MonsterId

  def self.generate(seed, size=nil)
    Monster.new(seed, size)
  end

end
