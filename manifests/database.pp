# = Define: couchdb::database
#
# Defines CouchDB Databases 
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
# [*server*]
#   String.  Url of the CouchDB Server
#   Default: undef
#
# [*ensure*]
#   String. Whether the database should be present or not 
#   Default: present 
#   Valid values: present, absent
#

define couchdb::database (
  $username                = 'admin',
  $password                = undef,
  $server                  = undef,
  $ensure                  = 'present',
) {

  validate_string($username, $password)
  validate_re($server, '^http', 'Only http urls are valid' )
  validate_re($ensure, ['^present$', '^absent$'] )

  couchdb_database {"$name":
    username => $username,
    password => $password,
    server   => $server,
    ensure   => $ensure,
  }

}
