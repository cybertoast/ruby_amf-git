require "rubygems"
require "active_record"
class Address < ActiveRecord::Base
  belongs_to :user
end