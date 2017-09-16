VCR.configure do |config|
  config.cassette_library_dir = "models/specs/vcr_cassettes"
  config.hook_into :webmock
end

