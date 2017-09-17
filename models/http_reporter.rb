require 'net/http'
require 'json'
require 'timeout'


class HttpReporter

  def initialize()

  end

  def seperate_addresses(addresses)
    url_array = addresses.split("\n")
    url_array.delete(" ")
    return url_array
  end

  def http_request(url)
   begin
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    return response

    # Not rescuing Net::HTTPBadResponse as we want to report on 404 requests.
   rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, Errno::ECONNREFUSED, Errno::EHOSTUNREACH, EOFError,  Net::HTTPHeaderSyntaxError, SocketError, Net::ProtocolError => error
    return false
   end
  end

  def generate_success_summary(request, response)
    summary = { 
    "Url" => request, 
    "StatusCode" => response.code, 

    # If the response was a multi-part MIME response, the content-length would be null. 
    # In this situation we use the body.length which has lower performance but still reports the correct length.
    "ContentLength" => response.content_length.nil? ? response.body.length : response.content_length,
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

  def summarise_all_urls(urls_string)
    urls_array = self.seperate_addresses(urls_string)
    json_summaries = []

    for url in urls_array

      if self.valid_url?(url)
        response = self.http_request(url)

        if response == false
          summary_hash = self.bad_address_summary(url)
          summary_json = self.jsonify(summary_hash)
          json_summaries << summary_json
        elsif response 
          summary_hash = self.generate_success_summary(url, response)
          summary_json = self.jsonify(summary_hash)
          json_summaries << summary_json
        end

      elsif !self.valid_url?(url)
        summary_hash = self.bad_address_summary(url)
        summary_json = self.jsonify(summary_hash)
        json_summaries << summary_json
      end
    end

    return json_summaries
  end

end