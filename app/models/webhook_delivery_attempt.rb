class WebhookDeliveryAttempt < ApplicationRecord
  belongs_to :webhook_delivery

  validates :response_code, presence: true

  def failure?
    !success?
  end

  def success?
    response_code.between?(200, 299)
  end

  def status
    case response_code
    when 200..299
      "success"
    else
      "failure"
    end
  end
end
