class WebhookDeliveriesController < ApplicationController
  def index
    @webhook_deliveries = WebhookDelivery.with_latest_attempt_summary.order(id: :desc)
  end

  def show
    @webhook_delivery = WebhookDelivery.includes(:webhook_delivery_attempts).find(params[:id])
    @webhook_delivery_attempts = @webhook_delivery.webhook_delivery_attempts.order(id: :desc)
  end
end
