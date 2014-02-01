require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data("<GITHUB OAUTH TOKEN>") { ENV.fetch("MOCHIFYDOINGWORK_OAUTH", "OAUTH_NOT_FOUND") }
end
