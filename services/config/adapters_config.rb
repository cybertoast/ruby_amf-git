##################################
#=>GLOBAL ADAPTER CONFIGURATION
#=>These shouldn't need to change, just uncomment any others if needed.
#
# Adapters are run against your service results. Your results can qualify to be 'adapted' by one of these adapters.
# Each adapter must have a 'use_adapter?' and 'run' method defined in it.
# 'use_adapter?' is used to qualify your results to be run against this adapter
# 'run' is used to run the results through the adapter, and alters your service result to whatever the adapter chooses.
# this happens before serializing the result from your service method
# See the MysqlAdapter or the ActiveRecordAdapter for an example of building an adapter
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