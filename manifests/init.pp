class couchdb (
  $bind_address = $couchdb::params::bind_address,
  $port = $couchdb::params::port,
  $backupdir = $couchdb::params::backupdir,

  $databases                  = {},
  $replications               = {},

) inherits ::couchdb::params {

  # Create resources from hiera lookups
  create_resources('::couchdb::database', $databases)
  create_resources('::couchdb::replication', $replications,)

  case $::osfamily {
    'Debian': { include ::couchdb::debian }
    'RedHat': { include ::couchdb::redhat }
    default:  { fail "couchdb not available for ${::operatingsystem}" }
  }
}
