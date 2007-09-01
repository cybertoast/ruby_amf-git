#Copyright (c) 2007 Aaron Smith (aaron@rubyamf.org) - MIT License
class ActiveRecord::Base
  @rubyamf_single_ar = false
  def as_single!
    @rubyamf_single_ar = true
    self
  end
  def single!
    @rubyamf_single_ar = true
    self
  end
  def single?
    @rubyamf_single_ar
  end
end