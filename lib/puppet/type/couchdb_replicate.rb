# This has to be a separate type to enable collecting
Puppet::Type.newtype(:couchdb_replicate) do
  @doc = %q{*Setup a replicator to a target server/database*

    Takes a CouchDB URL and a key as argument, and returns the value. If the key
    isn't found, it will return a parse error, or the value specified in the
    optional 3rd argument.

    Example:

            couchdb_replicate {'document_name':
              username        => admin,
              password        => moo,
              source_server   => "http://couchdb_source_server:5984",
              target_server   => "http://couchdb_target_server:5984",
              source_database => "source_database",
              target_database => "target_database",
              continuous      => true,
              ensure          => present,
            }
  }

  ensurable

  newparam(:name, :namevar => true) do
    desc "The name of the _replicator document."
  end

  newparam(:username) do
    desc "The name of the user. This uses the 'username@hostname' or username@hostname."
  end

  newparam(:password) do
    desc 'The authentication plugin of the user.'
  end

  newparam(:source_server) do
    desc 'The source server where the database resides'
  end

  newparam(:target_server) do
    desc 'The target server where to replicate the database to'
  end

  newparam(:source_database) do
    desc "The source database to replicate from"
  end

  newparam(:target_database) do
    desc "The target database to replicate to"
  end

  newparam(:continuous) do
    desc "Whether to continue replication even after the DB restarts"
  end
end
