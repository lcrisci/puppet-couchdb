# = Define: couchdb::replication
#
# Defines CouchDB Replications
#
# == Parameters
#
# [*username*]
#   String.  The username to use when authenticating
#   Default: admin
#
# [*password*]
#   String. The password to use when authenticating
#   Default: undef
#
# [*source_server*]
#   String.  Source server to replicate from
#   Default: undef
#
# [*target_server*]
#   String.  Destination server to replicate to
#   Default: undef
#
# [*source_database*]
#   String.  Source database to replicate from
#   Default: undef
#
# [*target_database*]
#   String.  Destination database to replicate to
#   Default: undef
#
# [*continuous*]
#   Bool.    Enable Continuous Replication
#   Default: true
#
# [*ensure*]
#   String. Whether the database should be present or not
#   Default: present
#   Valid values: present, absent
#

define couchdb::replication (
  $username                = 'admin',
  $password                = undef,
  $source_server           = undef,
  $target_server           = undef,
  $source_database         = undef,
  $target_database         = undef,
  $continuous              = true,
  $ensure                  = 'present',
) {

  couchdb_replicate {"$name":
    username        => $username,
    password        => $password,
    source_server   => $source_server,
    target_server   => $target_server,
    source_database => $source_database,
    target_database => $target_database,
    continuous      => $continuous,
    ensure          => $ensure,
  }

}
