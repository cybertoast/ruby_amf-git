class OpenStruct
  def id  
    @amf_id
  end
  
  def id=(v)
    @amf_id = v
  end
  
  def get_members
    members = self.marshal_dump.keys.map{|k| k.to_s}
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