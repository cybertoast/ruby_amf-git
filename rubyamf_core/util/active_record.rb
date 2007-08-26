#Active Record helper methods
class ActiveRecord::Base
  @rubyamf_single_ar = false
  def single!
    @rubyamf_single_ar = true
  end
  def single?
    @rubyamf_single_ar
  end
end