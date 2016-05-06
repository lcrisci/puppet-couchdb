#
# NB: this function has tests. If you change something, please also update
# spec/unit/puppet/parser/functions/couchdbreplicate_spec.rb
#
# You can run the tests with "rake spec"
#

module Puppet::Parser::Functions
  newfunction(:couchdbreplicate, :type => :rvalue, :doc => <<-EOS
*Setup a replicator to a remote server*

Takes a CouchDB URL and a key as argument, and returns the value. If the key
isn't found, it will return a parse error, or the value specified in the
optional 3rd argument.

*Example:*

    $localurl = "http://couchdblocaldb:5984"
    $localdb = "localdb"
    $remotedb = "http://couchdbremote:5984/remotedb"
    $continousreplication = "true"
    couchdbreplicate("${localurl}", "${localdb}", "${remotedb}", "${continuousreplication}")

If the "vagrantbox" fact is set, it will always return "undef" (assuming the
couchdb server is unreachable from inside a vagrant box).

  EOS
  ) do |args|
    require 'json'
    require 'open-uri'

    raise Puppet::ParseError, ("couchdbreplicate(): wrong number of arguments (#{args.length}; must be 3 or 4)") unless args.length.between?(3, 4)

    localurl = args[0]
    localdb = args[1]
    remotedb = args[2]
    continousreplication = args[3] if args.length >= 4

    replicatejson = {:source => localdb, :target => remotedb, :continuous => continousreplication}

    begin
      if exist?('vagrantbox') && lookupvar('vagrantbox') == true
        Puppet.send(:warning, "Bypassing couchdb lookup because 'vagrantbox' fact is defined. couchdbreplicate() will not return what you expect !")
        return default ? default : :undef
      end
    rescue Puppet::ParseError
      # do nothing
    end

    begin
      uri = URI.parse(localurl)
      headers = {'Content-Type'    => 'application/json',
                 'Accept-Encoding' => 'gzip,deflate',
                 'Accept'          => 'application/json'}
      http = Net::HTTP.new(uri.host,uri.port)
      response = http.post(uri.path, replicatejson.to_json, headers)
    rescue OpenURI::HTTPError, Timeout::Error, Errno::EINVAL,
           Errno::ECONNRESET, EOFError, Net::HTTPBadResponse,
           Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      raise Puppet::ParseError, "couchdbreplicate(): '#{e.message}'"
    end
  end
end
