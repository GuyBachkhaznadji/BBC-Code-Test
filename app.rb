require_relative( "./models/http_reporter.rb" )

http_reporter = HttpReporter.new()

puts("\nPlease enter the http requests you would like the details of:")
http_string = gets.chomp