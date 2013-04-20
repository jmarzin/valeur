# features/support/hooks.rb

Before do |scenario|
  Mongoid.purge!
end


