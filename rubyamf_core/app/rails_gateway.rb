#Copyright (c) 2007 Aaron Smith (aaron@rubyamf.org) - MIT License

require 'app/gateway'
require 'ostruct'
require 'util/object' #Include Object stuff here.
require 'util/openstruct' #Include Object stuff here.
require 'util/active_record' #Include active record updates
require 'util/action_controller' #Include action controller updates
require 'app/request_store'
require 'app/amf'
require 'exception/exception_handler'
require 'app/actions'
require 'app/filters'
require 'util/log'
require 'util/net_debug'
require 'logger'
require 'zlib'
include RUBYAMF::Actions
include RUBYAMF::App
include RUBYAMF::AMF
include RUBYAMF::Filter
include RUBYAMF::Exceptions
include RUBYAMF::Util

module RUBYAMF
module App

#Rails Gateway, extends regular gateway and changes the actions
class RailsGateway < Gateway
  
	def initialize
    super
		RequestStore.actions = Array[PrepareAction.new, ClassAction.new, RailsInvokeAction.new, ResultAdapterAction.new] #override the actions
		RequestStore.rails = true
	end
	
	#use_params_hash
  #This allows you to toggle how incoming method parameters get sent to your controller method
  #if false, parameters get sent to your controller in the method signature EX: myControllerMethod(param)
  #if true, parameters get mapped to the "params" variable that is available in your controller
	def use_params_hash=(val)
	  RequestStore.use_params_hash = val
	end
	
end
end
end