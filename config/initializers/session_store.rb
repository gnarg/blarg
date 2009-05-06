# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_blarg_session',
  :secret      => '0110539fb62ccf1bfa0fb2e9b11b983d19297baf3de37db6addcd67e209ae373cd156a58831c121fc1b82cce1d425068026f5689b90eb93f25a9fcbff9194b75'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
