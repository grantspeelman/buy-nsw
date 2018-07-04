class SlackPostJob < ApplicationJob
  def perform(message)
    if slack_webhook_url.present?
      RestClient.post slack_webhook_url, {text: message}.to_json, {content_type: :json}
    end
  end

  private

  def slack_webhook_url
    ENV["SLACK_WEBHOOK_URL"]
  end
end
