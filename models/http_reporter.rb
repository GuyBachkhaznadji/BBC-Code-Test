require 'net/http'
require 'json'

class HttpReporter

  def initialize()

  end

  def seperate_addresses(addresses)
    return addresses.split
  end

  def http_request(url)
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    return response
  end

  # def get_status_code(response)
  #   return response.code
  # end

end