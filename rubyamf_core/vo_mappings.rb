#Copyright (c) 2007 Aaron Smith (aaron@rubyamf.org) - MIT License

module VoMappings
def VoMappings.vos
  
  #VO Mappings are defined here. When you pass an object from Flex / Flash, if it is a VO
  #it get's caught by the "incoming" key, then is mapped_to the class defined in the "map_to"
  #hash. When the VO is returned to the client it is returned as the "outgoing" class.
  vo_maps = []
  vo_maps << {:incoming => 'test.mypackage.Person', :map_to => 'test.mypackage.Person', :outgoing => 'test.mypackage.Person'}
  vo_maps << {:incoming => 'test.mypackage.Person', :map_to => 'PersonFF', :outgoing => 'test.mypackage.Person'}
  
  #return vo_maps hash
  vo_maps
end
end