#Copyright (c) 2007 Aaron Smith (aaron@rubyamf.org) - MIT License
module VoMappings
def VoMappings.vos
  vos = []
  
  #Value Objects
  #VO Mappings are defined here. When you pass an object from Flex / Flash, if it is a VO / RemoteClass / Object.register_class
  #it get's caught by the "incoming" key, then is mapped to a new instance defined by the map_to key
  
  #Outgoing Objects
  #When something is returned from your service method, it is checked against the "map_to" hash.
  #if there is a match, the returned object to Flash / Flex is an instance of "outgoing"
  
  #RubyAMF Internal Knowledge of your VO's
  #There are two instance variables that are injected into your VO so RubyAMF knows what's going on #_explicitType and #rmembers.
  #Just a heads up if you inspect a VO, you'll see those key/vals. Don't remove them
  
  #Anonymous VO in Flex/ Flash
  #Flash / Flex can accept incoming VO's but will not cast them as that class. To fix that you need to create an instance of the VO type
  #somewhere in your applicaiton before any value objects are sent back to Flash / Flex.
  #If you are sending anonymous VO's you can do that with an entry like this:
  #vo_maps << {:incoming => '', :map_to => 'Person', :outgoing => 'my.package.Person'}  
  
  #Value Object Types
  #There are two modes a value object can be in. active_record, and vo
  #active_record mode instantiates and passes a valid ActiveRecord object to your service method. active_record mode only matters when a VO is Incoming
  #vo mode is just as it seems, a simple OpenStruct
  #EX: vos << {:incoming => 'test.mypackage.Person', :map_to => 'test.mypackage.Person', :outgoing => 'test.mypackage.Person', :mode => 'active_record'}
  
  #the vo directory is in services/service_vos
  vos << {:incoming => 'test.mypackage.Person', :map_to => 'test.mypackage.Person', :outgoing => 'test.mypackage.Person', :mode => 'active_record'}
  vos << {:incoming => '', :map_to => 'Person', :outgoing => 'Person'}
  
  #return vo_maps hash
  vos
end
end

#**dev note
#VO Mapping takes place in two places, AmfDeserializer#read_amf3_object / AmfSerializer#write_amf3
#Those both should be taken out of the de/serializers and moved into an ValueObjectTransformation action