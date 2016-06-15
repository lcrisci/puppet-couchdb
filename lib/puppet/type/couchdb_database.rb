# This has to be a separate type to enable collecting
Puppet::Type.newtype(:couchdb_database) do
  @doc = %q{*Manages CouchDB databases*

    Create or Delete a CouchDB database

    Example:

            couchdb_database {'database_name':
              username => admin,
              password => moo,
              server   => "http://localhost:5984",
              ensure   => present,
            }
  }

  ensurable

  newparam(:name, :namevar => true) do
    desc "The name of the CouchDB database."
  end

  newparam(:username) do
    desc "The user to authenticate with."
  end

  newparam(:password) do
    desc "The user's password."
  end

  newparam(:server) do
    desc 'The CouchDB server where the database resides'
  end
end
