# BBC Platform Programming Challenge - Ruby

## Installation

### Ruby
To check if you have already have Ruby installed go to your Terminal / Command Line.
This can be found easily on a Mac by pressing the cmd button and the space bar at the same time and typing "Terminal".

In your Terminal / Command Line run:

```
ruby -v
```

If that doesn't return the version we'll need to get you set up with Ruby or if the version.

Version 2.3 is the oldest version that is still supported.

If your version is below 2.3 I would recommend updating it by following the Homebrew instructions below. 

#### Installing Ruby on macOS with Homebrew
On OS X El Capitan, Yosemite, Mavericks, and macOS Sierra, Ruby 2.0 is included. OS X Mountain Lion, Lion, and Snow Leopard ship with Ruby 1.8.7.

Many people on OS X use Homebrew as a package manager. It is really easy to get a newer version of Ruby using [Homebrew](https://brew.sh/):

```
$ brew install ruby
```

This should install the latest Ruby version.

[Install Ruby not on a macOS](https://www.ruby-lang.org/en/documentation/installation/)

### Bundler
Once you're set up on Ruby to make getting all our dependencies easy we're going to use Bundler.

Installing bundler is easy! In your Terminal run: 

```
$ gem install bundler
```

We're almost done!

### Gem Dependencies
Now in the Terminal please navigate to the root directory for this project. Once there we're going to install our dependencies.

In your Terminal simply run:

```
bundle install
```

Great once that's finished we're good to go!

## Testing
This program is written in such a way that even though we're interacting with HTTP requests we don't need an internet connection to test it. 

We're using a really handy Ruby Gem called VCR which allows us to record our test suite's HTTP interactions and replay them during future test runs for fast, deterministic, accurate tests.

### Running Tests

Again this is simple. In the project's root directory run the command:

```
ruby run_tests.rb
```

## Running
Great we should be ready to run the app and see if it really works.

To run the app in the project's root directory run the below command:

```
ruby app.rb
```

The app is designed to take http requests separated by a new line.

Once you have finished inputting your http requests and want to see the results, press the "Tab" key followed by the "Enter" key.

## The Brief

The task is to write a program that makes http (and https) requests to specified URLs and to report on certain properties of the responses it receives; see requirements below. 

Please write your code in Java, Ruby or Python for a Linux/Unix platform. We will accept other languages but please check with us first. 

Your code should be sent to us as a zipped tar archive (.tgz file). We would like to see your version control commit history so please include .git or .svn directory structure in the tar archive. We prefer to see small incremental commits so the order in which your solution is developed is apparent. 

Please provide instructions so that we can install, test and run your program. 

If we invite you for an interview we will ask you to modify your program to meet an additional requirement or make other improvements. 

### Main Requirements 
* The program is invoked from the command line and it consumes its input from stdin. 
* The program output is written to stdout and errors are written to stderr. 
* Input format is a newline separated list of public web addresses, such as:
- http://www.bbc.co.uk/iplayer 
- https://google.com bad://address 
- http://www.bbc.co.uk/missing/thing 
- http://not.exists.bbc.co.uk/ 
- http://www.oracle.com/technetwork/java/javase/downloads/index.html 
- https://www.pets4homes.co.uk/images/articles/1646/large/kitten-emergencies-signs-to-look-out-for-537479947ec1c.jpg 
- http://site.mockito.org/ 

* The program should make an http GET request to each valid address in its input and record particular properties of the http response in the program output. 
* The properties of interest are status code, content length and date-time of the response. These are normally available in the http response headers.
* Output is a stream of JSON format documents that provide information about the http response for each address in the input, such as: 
* 
{ 
"Url": "http://www.bbc.co.uk/iplayer", 
"Status_code": 200, 
"Content_length": 209127, 
"Date": "Tue, 25 Jul 2017 17:00:55 GMT" 
} 

{ 
"Url": "https://google.com", 
"Status_code": 302, 
"Content_length": 262, 
"Date": "Tue, 25 Jul 2017 17:00:55 GMT" 
} 

{ 
"Url": "bad://address", 
"Error": "invalid url" 
}

*  The program should identify and report invalid URLs, e.g. those that don't start with http:// or https://, or contain characters not allowed in a URL. 
* The program should cope gracefully when it makes a request to a slow or non-responsive web server, e.g. it could time out the request after ten seconds. 
* The program should have a good set of unit tests. 
* It must be possible to perform a test run, consisting of all unit tests, without accessing the Internet. 


### Assessment criteria 
We will assess your submission based on the following 
* The quality of instructions for installing, running and testing the program. 
* How well the program meets the requirements. 
* The structure and clarity of your code and tests. 
* Evidence that you have taken a test driven approach during development. 

### Additional Requirement 
If you would like to show your skills a little more and you have sufficient time we invite you to make your program meet the following additional requirement. 

After emitting the stream of JSON documents an additional JSON document should be output. This final document summarises all the results providing a count of responses grouped by status code. Requests that receive no response (e.g. timeout or malformed url) may be ignored. 

The summary document should be something like this (i.e. array of objects): 

[ 
{ 
"Status_code": 200, 
"Number_of_responses": 15 
}, 
{ 
"Status_code": 404, 
"Number_of_responses": 6 
}, 
{ 
"Status_code": 302, 
"Number_of_responses": 5 
}, 
{ 
"Status_code": 403, 
"Number_of_responses": 2 
} 
]
