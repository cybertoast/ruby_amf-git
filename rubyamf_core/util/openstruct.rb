class OpenStruct
  
  def get_members
    members = self.marshal_dump.keys.map{|k| k.to_s}
    members
  end
  
  def to_hash
    hash= {}
    members = self.get_members
    members.each do |m|
      hash[m] = eval("self.#{m}")
    end
    if !self.id.nil?
      hash['id'] = self.id
    end
    hash
  end
end