class Webhook < ApplicationRecord
  has_many :webhook_secrets
  has_many :webhook_subscriptions
  belongs_to :organisation

  validates(
    :url,
    presence: true,
    format: { with: /\Ahttps:\/\/.*\z/, message: "must be https protocol" },
    unless: Proc.new { |webhook| localhost?(webhook.url) },
  )

  private

  def localhost?(url)
    %w[localhost 127.0.0.1].include?(URI.parse(url).host)
  end
end
