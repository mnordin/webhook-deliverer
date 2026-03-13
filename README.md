# Webhook Deliverer

A Rails app for delivering webhooks. Personal hobby project.

## Trying out the webhooks locally

Everything is set up for asyncronous delivery and turbostream updates from delivery attempts. Set up data using `rake db:seed` and use the rails console to update a user record. A new webhook delivery will be listed in the root page and attempts are added to that page through turbo streams.

## Webhook Models

- **Webhook** - Target endpoint URL that receives webhooks. Sets up a base url.
- **WebhookSubscription** - Subscribes a webhook to an event (`profile_created`, `profile_updated`, `profile_archived`). Has an optional path for segmenting each webhook.
- **WebhookDelivery** - Represents a single delivery with a `payload` to a subscription's full URL. Has many attempts.
- **WebhookDeliveryAttempt** - Records each HTTP request attempt. Success = 2xx response.
- **WebhookSecret** - Encrypted secret token for HMAC signing webhook payloads. Auto-generated on create.

## Future todos

- Full usage of view components
- Falcon and async/async-http-faraday to allow more concurrency. The webhook deliverer is bound to IO wait for response from the upstream server.
  - Implement throttling per top domain to not DDOS them
- Build web UI for user management, so we don't rely on `rails console` to trigger the webhook deliveries
  - Use service objects to enqueue webhook delivery jobs, instead of model callbacks
