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