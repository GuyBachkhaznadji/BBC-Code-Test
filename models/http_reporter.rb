require 'net/http'
require 'json'

class HttpReporter

  def initialize()

  end

  def seperate_addresses(addresses)
    return addresses.split
  end

end