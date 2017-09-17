require_relative( "./models/http_reporter.rb" )

http_reporter = HttpReporter.new()

puts "\nPlease enter a list of the http requests you would like the details of separated by a newline."
puts "After the list input 'tab' followed by 'enter' to run:"
user_input = gets("\t").chomp

puts "\n Making requests..."
reports_array = http_reporter.summarise_all_urls(user_input)
    
for report in reports_array
  puts "\n" + report + "\n"
end

status_code_summary = http_reporter.generate_status_code_summary(reports_array)
puts "\nStatus Code Report:"
puts status_code_summary