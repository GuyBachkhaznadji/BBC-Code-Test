require_relative( "./models/http_reporter.rb" )

http_reporter = HttpReporter.new()

question = "\nPlease enter a list of the http requests you would like the details of separated by a newline, then input 'tab' followed by 'enter':"

puts question
input = gets("\t").chomp

puts "\n Making requests..."
reports_array = http_reporter.summarise_all_urls(input)
    
for report in reports_array
  puts "\n" + report + "\n"
end
