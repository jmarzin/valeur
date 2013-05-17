# features/support/hooks.rb

Before do |scenario|
  Mongoid.purge!
  import = `mongoimport -d valeur_test -c parametrages --file test/fixtures/export`
end


