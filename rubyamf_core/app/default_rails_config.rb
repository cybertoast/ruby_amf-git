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
# :instance   #tells RubyAMF Lite to use this value object only if the incmoing request was under that application instances scope. (this is for RubyAMF Lite only)
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
#VALUE OBJECTS HERE
#ValueObjects.register({:incoming => 'Person', :map_to => 'Person', :outgoing => 'Person', :type => 'active_record'})
#ValueObjects.register({:incoming => 'User', :map_to => 'User', :outgoing => 'User', :type => 'active_record'})
#ValueObjects.register({:incoming => 'Address', :map_to => 'Address', :outgoing => 'Address', :type => 'active_record'})




##################################
#=>GLOBAL ADAPTER CONFIGURATION
#=>These shouldn't need to change, just uncomment any others if needed.
#
#Adapters are run against your service results. Your results can qualify to be 'adapted' by one of these adapters.
#Each adapter must have a 'use_adapter?' and 'run' method defined in it.
#'use_adapter?' is used to qualify your results to be run against this adapter
#'run' is used to actually run the results through the adapter, and alters your service result to whatever the adapter chooses.
#this happens before serializing the result
#See the MysqlAdapter or the ActiveRecordAdapter for an example of building an adapter
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