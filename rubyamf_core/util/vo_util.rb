#Copyright (c) 2007 Aaron Smith (aaron@rubyamf.org) - MIT License

#utility method to get a vo object mapping from the vo_mappings module
require 'vo_mappings'
require 'app/request_store'
require 'exception/rubyamf_exception'

class VoUtil
  
  #populate a VO from an OpenStruct
  def self.populateVoFromOpenStruct(vo,os)
    begin
      members = os.marshal_dump.keys.map{|k| k.to_s}
      members.each do |member|
        if member == "_explicitType" #if explicitType, keep going. define explicitType after vo population
          next
        end
        eval("vo.#{member} = os.#{member}")
      end
      
      #put _explicitType / rmembers on your VO, for RubyAMF handling
      class << vo
        attr_accessor :_explicitType
        attr_accessor :rmembers
      end
      vo._explicitType = self.getVoDefFromMappedRubyObj(os._explicitType)[:outgoing] #force _explicitType on the VO for serialization time, using the "outgoing"
      vo.rmembers = members
    rescue Exception => e
      raise RUBYAMFException.new(RUBYAMFException.USER_ERROR, e.message)
    end
    nil
  end
  
  #populate a VO from a generic Object
  def self.populateVoFromObject(vo,obj)
    begin
      members = obj.instance_variables.map{|mem| mem[1,mem.length]}
      members.each do |member|
        if member == "_explicitType" #if explicitType, keep going. define explicitType after vo population
          next
        end
        vo.instance_variable_set(:"@#{member}", obj.send("#{member}"))
      end
      
      #put _explicitType / rmembers on your VO
      class << vo
        attr_accessor :_explicitType
        attr_accessor :rmembers
      end
      vo._explicitType = self.getVoDefFromMappedRubyObj(vo.class.to_s)[:outgoing]
      vo.rmembers = members
    rescue Exception => e
      raise RUBYAMFException.new(RUBYAMFException.USER_ERROR, e.message)
    end
    nil
  end
  
  #get a VO definition from the client incoming class
  def self.getVoDefFromIncoming(incom)
    mappings = VoMappings.vos
    mappings.each do |map|
      if map[:incoming] == incom
        return map
      end
    end
    nil
  end
  
  #get an instance VO from the incoming type
  def self.getVoInstanceFromIncoming(incom)
    begin
      mappings = VoMappings.vos
      mappings.each do |map|
        if map[:incoming] == incom
          filepath = map[:map_to].split('.').join('/').to_s + '.rb' #set up filepath from the map_to symbol
          require RUBYAMF_VO + '/' + filepath #require the file
          return Object.const_get(incom.split('.').last).new #this returns an instance of the VO
        end
      end
    rescue LoadError => le
      raise RUBYAMFException.new(RUBYAMFException.VO_ERROR, "Tho VO definition #{incom} could not be found")
    end
    nil
  end
  
  #get a VO from a ruby mapped VO (a transitional object the map_to key of the map hash)
  def self.getVoDefFromMappedRubyObj(classname)
    mappings = VoMappings.vos
    m = '' #TODO - Fix me, why do I need to initialize m here ??
    mappings.each do |map|
      if map[:map_to] == classname
        m = map
        return map
      end
    end
    return m
  end
  
  def self.getVoInstanceFromMappedRubyObj(classname)
    begin
      mappings = VoMappings.vos
      mappings.each do |map|
        #TODO - change all this to use OpenStruct instead of VO_instance, that way the "incoming" key could be nil and not matter
        if map[:map_to] == classname
          filepath = map[:outgoing].split('.').join('/').to_s + '.rb' #set up filepath from the map_to symbol
          require RUBYAMF_VO + '/' + filepath #require the file
          return Object.const_get(classname.split('.').last).new #this returns an instance of the VO
        end
      end
    rescue LoadError => le
      raise RUBYAMFException.new(RUBYAMFException.VO_ERROR, "Tho VO definition #{classname} could not be found")
    end
    nil
  end
end