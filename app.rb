require_relative( "./models/http_reporter.rb" )

http_reporter = HttpReporter.new()

question = "\nPlease enter the http requests you would like the details of:"

puts question
input = gets.chomp

while (input != 'q') 
    puts "\n Talking to my friends online..."
    reports_array = http_reporter.summarise_all_urls(input)
    
    for report in reports_array
      puts report
    end

  input = gets.chomp
end