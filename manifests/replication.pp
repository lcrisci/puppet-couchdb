define couchdb::replication (
  $username                = 'admin',
  $password                = undef,
  $source_server           = '127.0.0.1',
  $target_server           = undef,
  $source_database         = undef,
  $target_database         = undef,
  $continuous_replication  = true,
  $ensure                  = 'present',
) {

  couchdb_replicate {"$name":
    username        => $username,
    password        => $password,
    source_server   => $source_server,
    target_server   => $target_server,
    source_database => $source_database,
    target_database => $target_database,
    continuous      => $continuous_replication,
    ensure          => $ensure,
  }

}
