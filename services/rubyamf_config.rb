##################################
#=>APPLICATION INSTANCES
#=>Application Instances are for RubyAMF Lite only.
#
#Application Instances define an 'Application scope' that allows RubyAMF to initialize ActiveRecord 
#and load models.They also create a scope for ValueObject definitions. If you have multiple applications 
#running in RubyAMF Lite with the same model names, you can declare a ValueObject to part of an 
#ApplicationInstance so that it will always use the right model.
#
#APPLICATION INSTANCE DEFINITIONS ARE NOT REQUIRED FOR RUBYAMF LITE TO FUNCTION PROPERLY.
#App instances main purpose is for incoming (from flex / flash) ActiveRecord value objects. Because 
#ActiveRecord must be connected before instantiating an AR instance. App instances allow RubyAMF to 
#catch requests, and do the neccessary active record connecting before you receive anything in your 
#service method. So if you're using ACtiveRecord value object's and are expecting ActiveRecord value objects 
#you MUST define an application instance.
#
#If you are not using ActiveRecore value objects, no application instances are neccessary, and 
#RubyAMF Lite will function as normal
#
#Application Instance Definitions include the name, source package path, EX: (org.myservice.*), database_config yaml file, 
#database_node (which defines which node from the yaml file to use), and a models_path
#
#For every request, RubyAMF Lite tries to match the target path (org.package.SomeService.getUsers) against 
#an Application Instance. If a matching App Instance is found for that request, ActiveRecord is initialized, 
#models are loaded and the database is connected to based on the matching Application Instance definition.
#
#You can use * in source definitions to include many class files that get initialized as an application.
#Here is an example application definition and what requsts it would match against.
#EX:
#  Application::Instance.register({
#     :name => 'universalremoting',
#     :source => 'org.universalremoting.browser.*',
#     :database_config => 'org/universalremoting/browser/test.yaml',
#     :database_node => 'development',
#     :models_path => 'org/universalremoting/browser/support/ar_models/*'
#   })
#  
#  :source => 'org.universalremoting.*.Testing
#  MATCHES:         org.universalremoting.hello.Testing.getString
#  NOT MATCHED:     org.universalremoting.some.package.Testing.getString
#
##################################
#APPLICATION INSTANCE DEFINITIONS HERE
Application::Instance.register({
  :name => 'universalremoting',
  :initialize => 'active_record',
  :source => 'org.universalremoting.browser.*',
  :database_config => 'org/universalremoting/browser/test.yaml',
  :database_node => 'development',
  :models_path => 'org/universalremoting/browser/support/ar_models/*'
})




##################################
#=> VALUE OBJECT DEFINITIONS
#=> Global and Application Instance Specific
#
#A Value Object definition conists of at least these three things:
# :incoming   #If an incoming value object is an instance of this type, the VO is turned into whatever the :map_to key specifies
# :map_to     #Defines what object to create if an incoming match is made.
              #If a result instance is the same as the :map_to key, it is sent back to Flex / Flash as an :outgoing
# :outgoing   #The class to send back to Flex / Flash
#
#Optional value object data
# :type       #Used to spectify the type of VO, valid options are 'active_record', 'custom',  (or don't specify at all)
# :instance   #tells RubyAMF to use this value object only if the incmoing request was under that application instances scope.
#
#If you are using ActiveRecord VO's you do not need to specify a fully qualified class path to the model, you can 
#just define the class name, 
#EX: ValueObjects.register({:incoming => 'Person', :map_to => 'Person', :outgoing => 'Person', :type => 'active_record'})
#
#If you are using custom VO's you would need to specify the fully qualified class path to the file
#EX: ValueObjects.register({:incoming => 'Person', :map_to => 'org.mypackage.Person', :outgoing => 'Person'})
#
#RubyAMF Internal Knowledge of your VO's
#If your VO's aren't active_records, there are two instance variables that are injected to your class so that RubyAMF knows what they are.
# '_explicitType' and 'rmembers'.
#That is just a heads up if you inspect a VO. Don't be surprised by those.
#
##################################
#APPLICATION INSTANCE SPECIFIC VALUE OBJECTS HERE
ValueObjects.register({:incoming => 'Person', :map_to => 'Person', :outgoing => 'Person', :type => 'active_record', :instance => 'universalremoting'})
ValueObjects.register({:incoming => 'User', :map_to => 'User', :outgoing => 'User', :type => 'active_record', :instance => 'universalremoting' })
ValueObjects.register({:incoming => 'Address', :map_to => 'Address', :outgoing => 'Address', :type => 'active_record', :instance => 'universalremoting'})

#GLOBAL VALUE OBJECTS HERE
#ValueObjects.register({:incoming => 'Person', :map_to => 'org.universalremoting.browser.support.vo.person', :outgoing => 'Person' })
#ValueObjects.register({:incoming => 'Person2', :map_to => 'org.universalremoting.browser.support.vo.person2', :outgoing => 'Person2' })
#ValueObjects.register({:incoming => '', :map_to => 'Person', :outgoing => 'Person' })




##################################
#=>GLOBAL ADAPTER CONFIGURATION
#=>These shouldn't need to change, just uncomment any others if needed.
#
#Adapters are run against your service results. Your results can qualify to be 'adapted' by one of these adapters.
#Each adapter must have a 'use_adapter?' and 'run' method defined in it.
#'use_adapter?' is used to qualify your results to be run against this adapter
#'run' is used to actually run the results through the adapter, and alters your service result to whatever the adapter chooses.
#this happens before serializing the result
##################################
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