class Object
  attr_accessor :_explicitType
  attr_accessor :rmembers
  attr_accessor :id
    
  def get_members
    members = obj.instance_variables.map{|mem| mem[1,mem.length]}
    members
  end
  
  def to_hash
    hash= {}
    members = self.get_members
    members.each do |m|
      hash[m] = self.send(:"#{k}")
    end
    if !self.id.nil?
      hash['id'] = self.id
    end
    hash
  end
end