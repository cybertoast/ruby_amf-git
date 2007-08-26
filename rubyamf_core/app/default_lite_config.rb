#Here you can configure Application Instances, Value Object mappings, Adapters, Application Instance Models

#---------------------------------------------
# =>  Application Instance Configuration
#---------------------------------------------
#An application instance is used as an Application Scope to define Adapters, ValueObjects, and Models protecting against 
#multiple VO's of the same name being instantiated. 

#If you have more than one application that passes "User" ValueObjects between client and server, the Application instance
#keeps you protected from instantiating, or sending out a "User" VO that was intended to be used in a different application.

#Take this for example: ValueObjects.register({:incoming => 'Person', :map_to => 'Person', :outgoing => 'Person'})
#This causes a problem if you have more than one Person VO in different applications.

#Application Instances are also used for initializing active_record models when using the RubyAMF Lite application server
#so that incoming Active Record VO's can be recieved as ActiveRecords in your service methods. 
#(As ActiveRecord needs to be connected before create instances of them)

#An application instance includes these definitions with one exception.

  #name
  #database configuration file
  #source path
  #models location (ONLY for RubyAMF Lite application server)
  #value object definitions

#The one exception here is models. When using RubyAMF and Rails, you DON'T need to define "registerModels" for an 
#application instance, as Rails initializes all models for you.

#If you're using the RubyAMF Lite application server AND Active Record VO Mappings you need to "registerModels". 
#This initializes ActiveRecords and your models so that incoming ActiveRecord VO's can be created and sent to your service method

#PLEASE READ THROUGH THE NEXT SECTION AS WELL, APPLICATION INSTANCE CONFIGURATION EXAMPLES FOLLOW THE "Value Objects" SECTION

#---------------------------------------------
# =>  Value Objects
#---------------------------------------------
#When you pass an object from Flex / Flash, if it is a VO / RemoteClass / Object.register_class
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
#There are two 'types' a value object can be. active_record, and vo
#active_record type instantiates and passes a valid ActiveRecord object to your service method. active_record mode only matters when a VO is Incoming
#vo mode is just as it seems, a simple OpenStruct
#EX: ValueObjects.register({:instance => 'rubyamf', :instances => [], :incoming => 'Person', :mapto => 'Person', :outgoing => 'Persong', :type => 'active_record'})
#ValueObjects.register({:incoming => 'test.mypackage.Person', :map_to => 'test.mypackage.Person', :outgoing => 'test.mypackage.Person'})
#ValueObjects.register({:incoming => 'User', :map_to => 'User', :outgoing => 'User', :type => 'active_record'})
#ValueObjects.register({:incoming => 'Address', :map_to => 'Address', :outgoing => 'Address', :type => 'active_record'})


#Here are some Application Instance configuration examples.

##RubyAMF AND Rails (no models needed)
  #pomodo configurations
  #Application::Instance.register({:name => 'pomodo', :source => 'org.pomodo.application.*', :database => 'org/pomodo/application/datbase.yaml' })
  #ValueObjects.register({:incoming => 'Address', :map_to => 'Address', :outgoing => 'Address', :type => 'active_record'})

  #rubyamf configurations
  #Application::Instance.register({:name => "rubyamf", :source => "org.rubyamf.amf.*", :database => 'org/rubyamf/amf/database.yaml'})

###RubyAMF Lite application server
  #myapp
  #Application::Instance.register({ :name => 'myapp', :source => 'org.myapp.*', :database => 'org/myapp/database.yaml', :models => 'org.myapp.*'})

#RUBYAMF TESTING
#Application::Instance.register({:name => 'rubyamf', :source => 'org.rubyamf.amf.*', :database => 'org/rubyamf/amf/test.yaml', :models => 'org/rubyamf/amf/models/'})










#---------------------------------------------
# =>  result Adapters
#---------------------------------------------
#ADAPTERS ARE APPLICATION INSTANCE INDEPENDENT
#Adapters are used to take a service method call result, and alter it in someway before sending it back to Flash,
#most commonly used for Database results.

#Adapters live in rubyamf_core/adapters/. in the array below, mysql_adapter is the mysql_adapter.rb file, and MysqlAdapter is the class
#defined in that file. Each adapter class must have a "user_adapter?" method defined that is used to determine if that adapter should 
#be used with the results passed to it. each Adapter file must also have a "run" method that is executed when the "use_adapter?" returns true
#you can look at either mysql_adapter or active_record_adapter for an example

#Adapters.register(:file => 'active_record_adapter', :classname => 'ActiveRecordAdapter')
#Adapters.register('firebird_fireruby_adapter', 'FirebirdFirerubyAdapter')
#Adapters.register('hypersonic_adapter','HypersonicAdapter')
#Adapters.register('lafcadio_adapter','LafcadioAdapter')
#Adapters.register('mysql_adapter', 'MysqlAdapter')
#Adapters.register('object_graph_adapter','ObjectGraphAdapter')
#Adapters.register('oracle_oci8_adapter', 'OracleOCI8Adapter')
#Adapters.register('postgres_adapter', 'PostgresAdapter')
#Adapters.register('ruby_dbi_adapter', 'RubyDBIAdapter')
#Adapters.register('sequel_adapter','SequelAdapter')
#Adapters.register('sqlite_adapter','SqliteAdapter')

















Application::Instance.register({
  :name => 'rubyamf', 
  :source => 'org.rubyamf.amf.AMFTesting', 
  :database_config => 'org/rubyamf/amf/test.yaml',
  :database_node => 'development',
  :models_path => 'org/rubyamf/amf/models/'
})

Application::Instance.register({
  :name => 'universalremoting',
  :source => 'org.universalremoting.browser.*',
  :database_config => 'org/universalremoting/browser/test.yaml',
  :database_node => 'development',
  :models_path => 'org/universalremoting/browser/support/ar_models/*'
})

ValueObjects.register({:incoming => 'User', :map_to => 'User', :outgoing => 'User', :type => 'active_record', :instance => 'universalremoting' })
ValueObjects.register({:incoming => 'Address', :map_to => 'Address', :outgoing => 'Address', :type => 'active_record', :instance => 'universalremoting'})
ValueObjects.register({:incoming => 'Hasselhoff', :map_to => 'Hasselhoff', :outgoing => 'Hasselhoff', :type => 'active_record'})
ValueObjects.register({:incoming => '', :map_to => 'Person', :outgoing => 'Person'})


Adapters.register('active_record_adapter', 'ActiveRecordAdapter')
#Adapters.register('firebird_fireruby_adapter', 'FirebirdFirerubyAdapter')
#Adapters.register('hypersonic_adapter','HypersonicAdapter')
#Adapters.register('lafcadio_adapter','LafcadioAdapter')
Adapters.register('mysql_adapter', 'MysqlAdapter')
#Adapters.register('object_graph_adapter','ObjectGraphAdapter')
#Adapters.register('oracle_oci8_adapter', 'OracleOCI8Adapter')
#Adapters.register('postgres_adapter', 'PostgresAdapter')
#Adapters.register('ruby_dbi_adapter', 'RubyDBIAdapter')
#Adapters.register('sequel_adapter','SequelAdapter')
#Adapters.register('sqlite_adapter','SqliteAdapter')