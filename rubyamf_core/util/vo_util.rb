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
    
      #put _explicitType on your VO
      class << vo
        attr_accessor :_explicitType
      end
      vo._explicitType = os._explicitType #force _explicitType on the VO for serialization time
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
          puts RUBYAMF_VO
          require RUBYAMF_VO + '/' + filepath #require the file
          return Object.const_get(incom.split('.').last).new #this returns an instance of the VO
        end
      end
    rescue LoadError => le
      raise RUBYAMFException.new(RUBYAMFException.VO_ERROR, "Tho VO definition #{incom} could not be found")
    end
    nil
  end
  
  #get a VO definition from the outgoing class name
  def self.getVoDefFromOutgoing(out)
    mappings = vos
    mappings.each do |map|
      if map[:outgoing] == incom
        return map
      end
    end
    nil
  end
  
  #get a VO from a ruby mapped VO (a transitional object the map_to key of the map hash)
  def self.getVoDefFromMappedRubyObj(classname)
    mappings = vos
    mappings.each do |map|
      if map[:map_to] == classname
        return map
      end
    end
    nil
  end
end