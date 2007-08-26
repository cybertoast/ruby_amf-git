#OpentStruct id fixes
class OpenStruct
  def id  
    @amf_id
  end
  def id=(v)
    @amf_id = v
  end
end