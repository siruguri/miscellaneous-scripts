class CreateUriRequests < ActiveRecord::Migration
  create_table :uri_requests do |t|
    t.string :uri
    t.string :ip
    t.timestamps
  end
end
