class WebhookDeliveryAttempt < ApplicationRecord
  belongs_to :webhook_delivery

  validates :response_code, presence: true

  def status
    case response_code
    when 200..299
      "success"
    else
      "failure"
    end
  end

  def failure?
    status == "failure"
  end
end
