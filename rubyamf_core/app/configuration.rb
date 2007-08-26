#Copyright (c) 2007 Aaron Smith (aaron@rubyamf.org) - MIT License

#This stores supporting configuration classes used in the config file to register, adapters, vo's, application instances, etc.

module RUBYAMF
module Configuration

class Application
  
  module Instance
    @@app_instances = []
    
    #register's an application instance
    def Instance.register(definition)
      if definition[:source] == nil || definition[:source] == ''
        return nil
      end
      if definition[:name] == nil || definition[:name] == ''
        return nil
      end
      if @@app_instances == nil
        @@app_instances = []
      end
      @@app_instances << definition
    end
    
    #Get an application instance definition from a target service
    def Instance.getAppInstanceDefFromTargetService(source)
      if source.nil?
        return nil
      end
      
      final_ai = nil
      @@app_instances.each do |ai|
        m = ai[:source].clone
        #create a simple regex here from a source package
        #org.rubyamf.amf.* => org\.rubyamf\.amf\..*
        #used to match against the ai[:source]
        m.gsub!('.','\.')
        m.gsub!('*','.*')
        if source.match(m)
          return ai
        end        
      end
      nil
    end
  end
end

class Adapters
  @@adpters = []
  def Adapters.register(file,classname)
    @@adpters << [file,classname]
  end
  
  def Adapters.get_adapters
    return @@adpters
  end
end

class ValueObjects
  
  @@vo_mappings = []
  @@vo_by_instances_lookup = {}
  
  def ValueObjects.register(hash)
    if hash[:instance] != nil
      if @@vo_by_instances_lookup[hash[:instance]].nil?
        @@vo_by_instances_lookup[hash[:instance]] = []
      end
      @@vo_by_instances_lookup[hash[:instance]] << hash
    else
      @@vo_mappings << hash
    end
  end
  
  def ValueObjects.get_vo_mappings
    return @@vo_mappings
  end
  
  def ValueObjects.get_vos_by_instance(instance)
    maps = []
    maps.concat(@@vo_mappings) #append all GLOBAL VO's to this array
    if !@@vo_by_instances_lookup.empty?
      if @@vo_by_instances_lookup[instance] != nil
        maps.concat(@@vo_by_instances_lookup[instance])
        return maps
      end
    end
    nil
  end
end

end
end