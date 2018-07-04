require 'rails_helper'

RSpec.describe SlackPostJob, type: :job do
  describe '#perform' do
    it 'sends a message to slack' do
      expect(RestClient).to receive(:post).with(
        "https://hooks.slack.com/services/abc/def/ghi",
        "{\"text\":\"This is an important message\"}",
        { content_type: :json }
      )
      
      described_class.perform_now("This is an important message")
    end
  end
end
