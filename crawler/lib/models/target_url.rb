class TargetUrl < ActiveRecord::Base
  belongs_to :my_queue
  has_many :url_payloads, dependent: :destroy
end
