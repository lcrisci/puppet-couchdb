require 'json'
require 'open-uri'

# Manage CouchDB replication

Puppet::Type.type(:couchdb_replicate).provide(:couchdb_replicate) do
  desc "Manages CouchDB replications."

  def create

    target_url = "#{resource[:target_server]}"+"/"+"#{resource[:target_database]}"

    begin
      uri = URI.parse(resource[:source_server])
      http = Net::HTTP.new(uri.host,uri.port)
      #http.use_ssl = true
      #http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new("/_replicator")
      request.basic_auth(resource[:username], resource[:password])
      request.add_field('Content-Type', 'application/json')
      request.body = {'_id' => resource[:name], 'source' => resource[:source_database], 'target' => target_url, 'continuous' => resource[:continuous]}.to_json
      response = http.request(request)
    rescue OpenURI::HTTPError, Timeout::Error, Errno::EINVAL,
           Errno::ECONNRESET, EOFError, Net::HTTPBadResponse,
           Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      raise Puppet::ParseError, "couchdb_replicate: '#{e.message}'"
    end
  end

  def destroy
    begin
      uri = URI.parse(resource[:source_server])
      http = Net::HTTP.new(uri.host,uri.port)
      #http.use_ssl = true
      #http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new("/_replicator/"+resource[:name])
      request.basic_auth(resource[:username], resource[:password])
      request.add_field('Content-Type', 'application/json')
      response = http.request(request)
      rev_id = JSON.parse(response.body())['_rev']

      request = Net::HTTP::Delete.new("/_replicator/"+resource[:name]+"?rev="+rev_id)
      request.basic_auth(resource[:username], resource[:password])
      response = http.request(request)
    rescue OpenURI::HTTPError, Timeout::Error, Errno::EINVAL,
           Errno::ECONNRESET, EOFError, Net::HTTPBadResponse,
           Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      raise Puppet::ParseError, "couchdb_replicate: '#{e.message}'"
    end
  end

  def exists?

    begin
      uri = URI.parse(resource[:source_server])
      http = Net::HTTP.new(uri.host,uri.port)
      #http.use_ssl = true
      #http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new("/_replicator/"+resource[:name])
      request.basic_auth(resource[:username], resource[:password])
      request.add_field('Content-Type', 'application/json')
      response = http.request(request)

      if response.code != "200"
        return false
      else
        return true
      end

    rescue OpenURI::HTTPError, Timeout::Error, Errno::EINVAL,
           Errno::ECONNRESET, EOFError, Net::HTTPBadResponse,
           Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      raise Puppet::ParseError, "couchdb_replicate: '#{e.message}'"
    end
  end
end
