require 'net/http'
require 'json'
require 'timeout'


class HttpReporter

  def initialize()

  end

  def seperate_addresses(addresses)
    return addresses.split("\n")
  end

  def http_request(url)
   begin
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    return response
   rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, Errno::ECONNREFUSED, Errno::EHOSTUNREACH, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => error
   end
  end

  def generate_success_summary(request, response)
    summary = { 
    "Url" => request, 
    "StatusCode" => response.code, 
    "ContentLength" => response["Content-Length"], 
    "Date" => response["Date"] 
    } 
    return summary
  end

  def jsonify(data)
    json = JSON.generate(data)
    return json
  end

  def valid_url?(url)
    if /\A#{URI::regexp(['http', 'https'])}\z/ =~ url
      return true
    else 
      return false
    end
  end

  def bad_address_summary(url)
    summary = { 
    "Url" => url, 
    "Error" => "Invalid URL"
    } 
    return summary
  end

end