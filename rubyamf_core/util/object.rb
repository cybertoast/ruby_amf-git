
#Object shortcuts and fixes
class Object
  def id
    return @amf_id
  end
  def id=(val)
    @amf_id = val
  end
end