# spec_helper.rb

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Mongoid::Matchers

  config.before :each do
    Mongoid.purge!
    str1 = File.open('test/fixtures/strategie.mrs', 'rb') { |file| file.read }
    param = Parametrage.new
    param = Marshal.load(str1).clone
    param.save!
  end
end


