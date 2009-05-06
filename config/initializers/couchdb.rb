couch_config = YAML.load(File.open("#{Rails.root}/config/couchdb.yml"))[Rails.env]
COUCHDB = CouchRest.database!("http://#{couch_config['host']}:#{couch_config['port']}/#{couch_config['database']}")
