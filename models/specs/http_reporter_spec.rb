require "minitest/autorun"
require "minitest/reporters"
require 'vcr'
require_relative "./support/vcr_setup.rb" 
require_relative "../http_reporter.rb" 
Minitest::Reporters.use!( Minitest::Reporters::SpecReporter.new )


describe "Http Reporter" do

  before do
  
  end


end