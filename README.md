# Webhook Deliverer

A Rails app for delivering webhooks. Personal hobby project.

## Webhook Models

- **Webhook** - Target endpoint URL that receives webhooks. Sets up a base url.
- **WebhookSubscription** - Subscribes a webhook to an event (`profile_created`, `profile_updated`, `profile_archived`). Has an optional path for segmenting each webhook.
- **WebhookDelivery** - Represents a single delivery attempt to a subscription's full URL.
- **WebhookDeliveryAttempt** - Records each HTTP request attempt. Success = 2xx response.
- **WebhookSecret** - Encrypted secret token for HMAC signing webhook payloads. Auto-generated on create.
