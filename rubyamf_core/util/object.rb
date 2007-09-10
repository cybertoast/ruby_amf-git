require 'app/configuration'
class Object
  
  attr_accessor :_explicitType
  attr_accessor :rmembers
  attr_accessor :id
  
  def get_members
    members = obj.instance_variables.map{|mem| mem[1,mem.length]}
    if !self.id.nil?
      members << 'id'
    end
    members
  end
  
  def to_hash
    hash = {}
    members = self.get_members
    members.each do |k|
      val = self.send(:"#{k}")
      hash[k] = val
    end
    if self.id != nil
      hash['id'] = self.id
    end
    hash
  end
end