class UrlPayload < ActiveRecord::Base
  belongs_to :target_url

  serialize :payload, Hash
end

