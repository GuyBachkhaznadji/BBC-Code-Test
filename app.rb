require_relative( "./models/http_reporter.rb" )

http_reporter = HttpReporter.new()

puts("\nPlease enter the http requests you would like the details of:")
http_string = gets.chomp
response = http_reporter.http_request(http_string)
summary = http_reporter.generate_summary(http_string, response)

puts summary