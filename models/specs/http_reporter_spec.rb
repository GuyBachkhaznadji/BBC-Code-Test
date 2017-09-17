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
    @valid_url_http = "http://www.bbc.co.uk"
    @invalid_url = "https://google.com bad://address"
    @invalid_url_pipes = "https:||www.bbc.co.uk"
    @valid_url_html = "http://www.oracle.com/technetwork/java/javase/downloads/index.html"
    @valid_url_jpg = "https://www.pets4homes.co.uk/images/articles/1646/large/kitten-emergencies-signs-to-look-out-for-537479947ec1c.jpg"
    @no_server_url = "http://www.bbc.co.uk/missing/thing"
    @all_addresses = "http://www.bbc.co.uk/iplayer\nhttps://google.com bad://address\nhttp://www.bbc.co.uk/missing/thing\nhttp://not.exists.bbc.co.uk/\nhttp://www.oracle.com/technetwork/java/javase/downloads/index.html\nhttps://www.pets4homes.co.uk/images/articles/1646/large/kitten-emergencies-signs-to-look-out-for-537479947ec1c.jpg\nhttp://site.mockito.org/"

    VCR.use_cassette("valid_url") do
      @valid_response = @http_reporter.http_request(@valid_url)
    end

  end

  it " Should separate the URLs by line" do
    result = @http_reporter.seperate_addresses(@all_addresses)
    expected = ["http://www.bbc.co.uk/iplayer", "https://google.com bad://address", "http://www.bbc.co.uk/missing/thing", "http://not.exists.bbc.co.uk/", "http://www.oracle.com/technetwork/java/javase/downloads/index.html", "https://www.pets4homes.co.uk/images/articles/1646/large/kitten-emergencies-signs-to-look-out-for-537479947ec1c.jpg", "http://site.mockito.org/"]
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
      "Url" => "https://www.bbc.co.uk", 
      "StatusCode" => "200", 
      "ContentLength" => "42335", 
      "Date" => "Sat, 16 Sep 2017 21:24:09 GMT" 
    } 
    assert_equal( expected, result )
  end

  it " Should convert the request's details as JSON" do
    summary_hash = @http_reporter.generate_success_summary(@valid_url, @valid_response)
    result =  @http_reporter.jsonify(summary_hash)
    expected = "{\"Url\":\"https://www.bbc.co.uk\",\"StatusCode\":\"200\",\"ContentLength\":\"42335\",\"Date\":\"Sat, 16 Sep 2017 21:24:09 GMT\"}"    
    assert_equal( expected, result )
  end

  it " Should identify invalid URLs with spaces" do
      result = @http_reporter.valid_url?(@invalid_url)
      assert_equal( false, result )
  end

  it " Should identify invalid URLs with pipes" do
      result = @http_reporter.valid_url?(@invalid_url_pipes)
      assert_equal( false, result )
  end

  it " Should identify valid URLs starting https" do
      result = @http_reporter.valid_url?(@valid_url)
      assert_equal( true, result )
  end

  it " Should identify valid URLs starting http" do
      result = @http_reporter.valid_url?(@valid_url_http)
      assert_equal( true, result )
  end

  it " Should identify valid URLs ending html" do
      result = @http_reporter.valid_url?(@valid_url_html)
      assert_equal( true, result )
  end

  it " Should identify valid URLs ending jpg" do
      result = @http_reporter.valid_url?(@valid_url_jpg)
      assert_equal( true, result )
  end

  it " Should generate error message hash error message" do
    result = @http_reporter.bad_address_summary(@invalid_url)
     expected = { 
       "Url" => "https://google.com bad://address", 
       "Error" => "Invalid URL"
     } 
     assert_equal( expected, result )
  end

  it " Should not crash if web server is not responsive" do
    VCR.use_cassette("no_server_url") do
      result = @http_reporter.http_request(@no_server_url)
      assert_equal( "Not Found", result.message )
    end
  end

  it " Should output a stream of JSON for all addresses entered" do
    VCR.use_cassette("all_urls", :record => :new_episodes) do
      result = @http_reporter.check_all_urls(@all_addresses)
      expected = [""]
      assert_equal( expected, result )
    end
  end

  it " Should timeout request after 10 seconds" do
    skip
  end

  it " Should count all results by status code" do
    skip
  end

  it " Should output an array of status code counts" do
    skip
  end

  it " Should output JSON array of status codes" do
    skip
  end

end