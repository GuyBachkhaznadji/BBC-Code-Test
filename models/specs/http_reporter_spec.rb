require "minitest/autorun"
require "minitest/reporters"
require 'vcr'
require_relative "./support/vcr_setup.rb" 
require_relative "../http_reporter.rb" 
Minitest::Reporters.use!( Minitest::Reporters::SpecReporter.new )


describe "Http Reporter" do

  before do
    @http_reporter = HttpReporter.new()
    @valid_addresses_str = "https://www.bbc.co.uk\nhttps://www.theguardian.com/uk"
    @valid_url = "https://www.bbc.co.uk"
    @invalid_url = "https://google.com bad://address"
    @no_server_url = "http://www.bbc.co.uk/missing/thing"
    @multiple_addresses = "http://www.bbc.co.uk/iplayer\nhttps://google.com bad://address\nhttp://www.bbc.co.uk/missing/thing"

    VCR.use_cassette("valid_url") do
      @valid_response = @http_reporter.http_request(@valid_url)
    end

    VCR.use_cassette("all_urls", :record => :new_episodes) do
      @summary_json_array = @http_reporter.summarise_all_urls("http://www.bbc.co.uk/iplayer\nhttps://google.com bad://address\nhttp://www.bbc.co.uk/missing/thing\nhttp://not.exists.bbc.co.uk/\nhttp://www.oracle.com/technetwork/java/javase/downloads/index.html\nhttps://www.pets4homes.co.uk/images/articles/1646/large/kitten-emergencies-signs-to-look-out-for-537479947ec1c.jpg\nhttp://site.mockito.org/ ")
    end
  end

  it " Should separate the URLs by line" do
    result = @http_reporter.seperate_addresses(@multiple_addresses)
    expected = ["http://www.bbc.co.uk/iplayer", "https://google.com bad://address", "http://www.bbc.co.uk/missing/thing"]
    assert_equal( expected, result )
  end

  it " Should make a http GET request to the URL" do
    VCR.use_cassette("valid_url") do
      result = @http_reporter.http_request(@valid_url)
      assert_equal( "OK", result.message )
    end
  end

  it " Should record the status code" do
    VCR.use_cassette("valid_url") do
      result = @http_reporter.http_request(@valid_url)
      assert_equal( "200", result.code )
    end
  end

  it " Should record the content length" do
    VCR.use_cassette("valid_url") do
      result = @http_reporter.http_request(@valid_url)
      assert_equal( "42335", result["Content-Length"] )
    end
  end

  it " Should record the date-time of the response" do
    VCR.use_cassette("valid_url") do
      result = @http_reporter.http_request(@valid_url)
      assert_equal( "Sat, 16 Sep 2017 21:24:09 GMT", result["Date"] )
    end
  end

  it " Should generate a summary hash" do
    result = @http_reporter.generate_success_summary(@valid_url, @valid_response)
    expected = { 
      "url" => "https://www.bbc.co.uk", 
      "statusCode" => "200", 
      "contentLength" => 42335, 
      "date" => "Sat, 16 Sep 2017 21:24:09 GMT" 
    } 
    assert_equal( expected, result )
  end

  it " Should convert the request's details as JSON" do
    summary_hash = @http_reporter.generate_success_summary(@valid_url, @valid_response)
    result =  @http_reporter.jsonify(summary_hash)
    expected = "{
  \"url\": \"https://www.bbc.co.uk\",
  \"statusCode\": \"200\",
  \"contentLength\": 42335,
  \"date\": \"Sat, 16 Sep 2017 21:24:09 GMT\"
}"    
    assert_equal( expected, result )
  end

  it " Should identify invalid URLs with spaces" do
      result = @http_reporter.valid_url?(@invalid_url)
      assert_equal( false, result )
  end

  it " Should identify invalid URLs with pipes" do
      result = @http_reporter.valid_url?("https:||www.bbc.co.uk")
      assert_equal( false, result )
  end

  it " Should identify valid URLs starting https" do
      result = @http_reporter.valid_url?(@valid_url)
      assert_equal( true, result )
  end

  it " Should identify valid URLs starting http" do
      result = @http_reporter.valid_url?("http://www.bbc.co.uk")
      assert_equal( true, result )
  end

  it " Should identify valid URLs ending html" do
      result = @http_reporter.valid_url?("http://www.oracle.com/technetwork/java/javase/downloads/index.html")
      assert_equal( true, result )
  end

  it " Should identify valid URLs ending jpg" do
      result = @http_reporter.valid_url?("https://www.pets4homes.co.uk/images/articles/1646/large/kitten-emergencies-signs-to-look-out-for-537479947ec1c.jpg")
      assert_equal( true, result )
  end

  it " Should generate error message hash error message" do
    result = @http_reporter.bad_address_summary(@invalid_url)
     expected = { 
       "url" => "https://google.com bad://address", 
       "error" => "Invalid URL"
     } 
     assert_equal( expected, result )
  end

  it " Should not crash if web server is not responsive" do
    VCR.use_cassette("no_server_url") do
      result = @http_reporter.http_request(@no_server_url)
      assert_equal( "Not Found", result.message )
    end
  end

  it " Should output JSON summary for all addresses entered" do
    VCR.use_cassette("all_urls", :record => :new_episodes) do
      result = @http_reporter.summarise_all_urls(@multiple_addresses)
      expected = ["{
  \"url\": \"http://www.bbc.co.uk/iplayer\",
  \"statusCode\": \"301\",
  \"contentLength\": 83,
  \"date\": \"Sun, 17 Sep 2017 15:08:59 GMT\"
}", "{
  \"url\": \"https://google.com bad://address\",
  \"error\": \"Invalid URL\"
}", "{
  \"url\": \"http://www.bbc.co.uk/missing/thing\",
  \"statusCode\": \"404\",
  \"contentLength\": 50228,
  \"date\": \"Sun, 17 Sep 2017 15:48:57 GMT\"
}"]
      assert_equal( expected, result )
    end
  end

  it " Should return an array of status codes" do
    result = @http_reporter.get_status_codes(@summary_json_array)
    assert_equal(["301", "404", "200", "200", "200"], result)
  end

  it " Should count all results by status code" do
    status_codes_array = @http_reporter.get_status_codes(@summary_json_array)
    result = @http_reporter.count_status_codes(status_codes_array)
    assert_equal([{"statusCode"=>"200", "numberOfResponses"=>3}, {"statusCode"=>"301", "numberOfResponses"=>1}, {"statusCode"=>"404", "numberOfResponses"=>1}], result)
  end

  it " Should from http summary JSON produce the status code summary in JSON" do
    result = @http_reporter.generate_status_code_summary(@summary_json_array)
    expected = "[
  {
    \"statusCode\": \"200\",
    \"numberOfResponses\": 3
  },
  {
    \"statusCode\": \"301\",
    \"numberOfResponses\": 1
  },
  {
    \"statusCode\": \"404\",
    \"numberOfResponses\": 1
  }
]"
    assert_equal(expected, result)
  end

end