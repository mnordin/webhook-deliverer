require "test_helper"

class WebhooksIntegrationTest < ActionDispatch::IntegrationTest
  test "creating a new user sends a profile_created webhook" do
    travel_to(Time.zone.parse("2024-10-31 14:00:00")) do
      organisation = create(:organisation)
      department = create(:department, organisation:)
      manny = create(:user, name: "Manny Calavera", department:)
      webhook = create(:webhook, url: "https://example.com/foo/", organisation:)
      create(
        :webhook_subscription,
        webhook:,
        event: "profile_created",
        relative_path: "/bar",
      )
      secret = create(:webhook_secret, :active, webhook:, secret: "static-secret")
      guybrush = build(
        :user,
        name: "Guybrush Threepwood",
        work_email: "guybrush@lucasarts.com",
        personal_email: "guybrush@gmail.com",
        job_title: "Swashbuckling Pirate",
        first_day_of_work: "2024-10-31",
        manager: manny,
        department:,
      )
      expected_payload = {
        type: "profile_created",
        data: {
          # Expectation is set up before the user is persisted and gets an id.
          id: User.maximum(:id).to_i.next,
          name: "Guybrush Threepwood",
          work_email: "guybrush@lucasarts.com",
          personal_email: "guybrush@gmail.com",
          job_title: "Swashbuckling Pirate",
          first_day_of_work: "2024-10-31",
          created_at: "2024-10-31T14:00:00Z",
          updated_at: "2024-10-31T14:00:00Z",
          manager_name: "Manny Calavera"
        }
      }
      expected_url = "https://example.com/foo/bar"
      webhook_request = stub_request(:post, expected_url).with(
        body: expected_payload.to_json,
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Content-Type" => "application/json",
          "User-Agent" => "Webhook Deliverer Client",
          # The request id is a UUID. For this high level test, we don't care that much about
          # the content of it, only that it is part of the headers.
          "X-Request-Id" => /\A(\w|-){36}\z/,
          "X-Signature" => "0e3dc1e17c43939bca0ac13cac9753460e3db05eb445073bdd91e53afcc877df",
          "X-Timestamp" => Time.zone.now.to_i.to_s
        }
      ).to_return(status: 200, body: { status: "success" }.to_json)

      perform_enqueued_jobs do
        guybrush.save!
      end

      webhook_delivery = WebhookDelivery.last
      assert_equal(
        {
          status: "success",
          last_response_code: 200,
          last_response: { status: "success" }.to_json,
          attempts: 1,
          url: expected_url
        }.with_indifferent_access,
        webhook_delivery.slice(:status, :last_response_code, :last_response, :attempts, :url)
      )
      assert_equal expected_payload.to_json, webhook_delivery.payload
      assert_equal Time.zone.now, secret.reload.last_used_at
      assert_requested webhook_request
    end
  end
end
