require "minitest/autorun"
require "minitest/reporters"
require 'vcr'
require_relative "./support/vcr_setup.rb" 
require_relative "../http_reporter.rb" 
Minitest::Reporters.use!( Minitest::Reporters::SpecReporter.new )


describe "Http Reporter" do

  before do
    @all_valid_http_string = "https://www.bbc.co.uk \n https://www.theguardian.com/uk"
  end

  it " Should separate the URLs by line" do
    skip
  end

  it " Should make a http GET request to the URL" do
    skip
  end

  it " Should check that the URL is valid" do
    skip
  end

  it " Should record the status code" do
    skip
  end

  it " Should record the content length" do
    skip
  end

  it " Should record the date-time of the response" do
    skip
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