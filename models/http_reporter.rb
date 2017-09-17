require 'net/http'
require 'json'
require 'timeout'


class HttpReporter

  def initialize()

  end

  def seperate_addresses(addresses)
    urls_array = addresses.split("\n")
    urls_array.delete(" ")
    urls_array.delete("\t")
    return urls_array
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
    "url" => request, 
    "statusCode" => response.code, 

    # If the response was a multi-part MIME response, the content-length would be null. 
    # In this situation we use the body.length which has lower performance but still reports the correct length.
    "contentLength" => response.content_length.nil? ? response.body.length : response.content_length,
    "date" => response["Date"] 
    } 
    return summary
  end

  def jsonify(data)
    json = JSON.pretty_generate(data)
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
    "url" => url, 
    "error" => "Invalid URL"
    } 
    return summary
  end

  def summarise_all_urls(urls_string)
    urls_array = self.seperate_addresses(urls_string)
    json_summaries = []

    for url in urls_array
      url.rstrip!
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

  def get_status_codes(json_array)
    status_code_array = json_array.map{ |json_hash| 
      JSON.parse(json_hash)["statusCode"]
    }
    return status_code_array.compact
  end

  def count_status_codes(collected_status_codes)
    status_codes_hashes = [] 
    collected_status_codes.sort!
    unique_status_codes = collected_status_codes.uniq
    unique_codes_index = 0

    # Chose to avoid a nested loop.
    # Compares the unique codes to all the collected status codes.
    for status_code in collected_status_codes

      # Adds to the counts if this status code matches the unique code but the array of hashes is currently empty.
      if status_code == unique_status_codes[unique_codes_index] && !status_codes_hashes.empty? && status_codes_hashes[unique_codes_index]["statusCode"] == status_code

        status_codes_hashes[unique_codes_index]["numberOfResponses"] += 1
      
      # Adds to the count of the hash if that this status code matches it.
      elsif status_code == unique_status_codes[unique_codes_index] && status_codes_hashes.empty?
        status_code_hash = {
          "statusCode" => status_code,
          "numberOfResponses" => 1
        }
        status_codes_hashes << status_code_hash
      
      # Generates a hash for that status code if it doesn't already exist.
      elsif status_code != unique_status_codes[unique_codes_index] && status_code == unique_status_codes[unique_codes_index + 1]
        status_code_hash = {
          "statusCode" => status_code,
          "numberOfResponses" => 1
        }
        status_codes_hashes << status_code_hash 
        unique_codes_index += 1
      end
    end

    return status_codes_hashes
  end

  def generate_status_code_summary(json_array)
    status_code_array = self.get_status_codes(json_array)
    status_code_count = self.count_status_codes(status_code_array)
    return self.jsonify(status_code_count)
  end

end