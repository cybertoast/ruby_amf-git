require 'app/configuration'
class Object
  
  attr_accessor :_explicitType
  attr_accessor :rmembers
    
  def id
    return @amf_id
  end
  
  def id=(val)
    @amf_id = val
  end
  
  def get_members
    members = obj.instance_variables.map{|mem| mem[1,mem.length]}
    members
  end
  
  def to_hash
    hash = {}
    members = self.get_members
    members.each do |k|
      val = self.send(:"#{k}")
      hash[k] = val
    end
    hash
  end
end