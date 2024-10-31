require "test_helper"

module Webhooks
  class ResponseTest < ActiveSupport::TestCase
    test "#success? returns true for a successful response" do
      successful_response = Faraday::Response.new(status: 200)
      response = Response.new(successful_response)

      assert response.success?
    end

    test "#failure? returns false for a successful response" do
      successful_response = Faraday::Response.new(status: 200)
      response = Response.new(successful_response)

      assert_equal response.failure?, false
    end

    test "#success? returns false for an unsucessful response" do
      unsuccessful_response = Faraday::Response.new(status: 500)
      response = Response.new(unsuccessful_response)

      assert_equal response.success?, false
    end

    test "#failure? returns true for a unsucessful response" do
      unsuccessful_response = Faraday::Response.new(status: 500)
      response = Response.new(unsuccessful_response)

      assert response.failure?
    end

    test "#status is delegated to the underlying response" do
      response_mock = Minitest::Mock.new
      response_mock.expect(:status, 201)

      response = Response.new(response_mock)

      assert_equal response.status, 201
      response_mock.verify
    end

    test "#body is delegated to the underlying response" do
      response_mock = Minitest::Mock.new
      body = { id: 1 }.to_json
      response_mock.expect(:body, body)

      response = Response.new(response_mock)

      assert_equal response.body, body
      response_mock.verify
    end
  end
end
