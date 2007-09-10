class OpenStruct  
  def get_members
    members = self.marshal_dump.keys.map{|k| k.to_s}
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