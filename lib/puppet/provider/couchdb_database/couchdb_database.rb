require 'json'
require 'open-uri'

# Manage CouchDB Database

Puppet::Type.type(:couchdb_database).provide(:couchdb_database) do
  desc "Manages CouchDB Databases."

  def create

    begin
      uri = URI.parse(resource[:server])
      http = Net::HTTP.new(uri.host,uri.port)
      #http.use_ssl = true
      #http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Put.new("/"+resource[:name]+"/")
      request.basic_auth(resource[:username], resource[:password])
      response = http.request(request)

    rescue OpenURI::HTTPError, Timeout::Error, Errno::EINVAL,
           Errno::ECONNRESET, EOFError, Net::HTTPBadResponse,
           Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      raise Puppet::ParseError, "couchdb_database: '#{e.message}'"
    end

    if response.code != "201"
      raise Puppet::Error, "Database Setup failed with the following HTTP response code: #{response.code}"
    end
  end

  def destroy
    begin
      uri = URI.parse(resource[:server])
      http = Net::HTTP.new(uri.host,uri.port)
      #http.use_ssl = true
      #http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Delete.new("/"+resource[:name]+"/")
      request.basic_auth(resource[:username], resource[:password])
      response = http.request(request)

    rescue OpenURI::HTTPError, Timeout::Error, Errno::EINVAL,
           Errno::ECONNRESET, EOFError, Net::HTTPBadResponse,
           Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      raise Puppet::ParseError, "couchdb_database: '#{e.message}'"
    end

    if response.code != "200"
      raise Puppet::Error, "Database Removal failed with the following HTTP response code: #{response.code}"
    end
  end

  def exists?

    begin
      uri = URI.parse(resource[:server])
      http = Net::HTTP.new(uri.host,uri.port)
      #http.use_ssl = true
      #http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new("/"+resource[:name]+"/")
      request.basic_auth(resource[:username], resource[:password])
      response = http.request(request)

      if response.code != "200"
        return false
      else
        return true
      end

    rescue OpenURI::HTTPError, Timeout::Error, Errno::EINVAL,
           Errno::ECONNRESET, EOFError, Net::HTTPBadResponse,
           Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      raise Puppet::ParseError, "couchdb_database: '#{e.message}'"
    end
  end
end
