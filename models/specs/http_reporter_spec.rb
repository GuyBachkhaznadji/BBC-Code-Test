require "minitest/autorun"
require "minitest/reporters"
require 'vcr'
require_relative "./support/vcr_setup.rb" 
require_relative "../http_reporter.rb" 
Minitest::Reporters.use!( Minitest::Reporters::SpecReporter.new )


describe "Http Reporter" do

  before do
    @http_reporter = HttpReporter.new()
    @valid_addresses_str = "https://www.bbc.co.uk \n https://www.theguardian.com/uk"
    @valid_url = "https://www.bbc.co.uk"
    VCR.use_cassette("valid_url") do
      @valid_response = @http_reporter.http_request(@valid_url)
    end
  end

  it " Should separate the URLs by line" do
    result = @http_reporter.seperate_addresses(@valid_addresses_str)
    assert_equal( ["https://www.bbc.co.uk", "https://www.theguardian.com/uk"], result )
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
    result = @http_reporter.generate_summary(@valid_url, @valid_response)
    expected = { 
      "Url" => "https://www.bbc.co.uk", 
      "StatusCode" => "200", 
      "ContentLength" => "42335", 
      "Date" => "Sat, 16 Sep 2017 21:24:09 GMT" 
    } 
    assert_equal( expected, result)
  end

  it " Should convert the request's details as JSON" do
    skip
  end

  it " Should identify invalid URLs" do
    skip
  end

  it " Should record error message for invalid URL" do
    skip
  end

  it " Should output JSON with different details for invalid URLs" do
    skip
  end

  it " Should not crash if web server is not responsive" do
    skip
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