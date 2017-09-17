# BBC Platform Programming Challenge - Ruby

## Installation

### Ruby
To check if you have already have Ruby installed go to your Terminal / Command Line.
This can be found easily on a Mac by pressing the cmd button and the space bar at the same time and typing "Terminal".

In your Terminal / Command Line run:

```
ruby -v
```

If that doesn't return the version we'll need to get you set up with Ruby. 

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

Again this is simply. In the projects root directory run the command:

```
ruby run_tests.rb
```

## Running
Great we should be ready to run the app and see if it really works.

To run the app in the projects root directory run the below command:

```
ruby app.rb
```

The app is designed to take http requests separated by a new line.

Once you have finshed inputting your http requests and want to see the results, press the "Tab" key followed by the "Enter" key.
