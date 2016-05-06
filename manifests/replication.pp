define couchdb::replication (
  $username                = 'admin',
  $password                = undef,
  $source_server           = '127.0.0.1',
  $target_server           = undef,
  $target_database         = undef,
  $continuous_replication  = true,
  $ensure                  = 'present',
) {

  $source_database = $name

  couchdb_replicate {"$source_database":
    username        => $username,
    password        => $password,
    source_server   => $source_server,
    target_server   => $target_server,
    target_database => $target_database,
    continuous      => $continuous_replication,
    ensure          => $ensure,
  }

}
