FactoryBot.define do
  factory :feedback_item do
    task 'Trying to do a thing'
    issue 'Having a problem'
    user
    url 'http://example.org/cloud'
    referer 'http://example.org/referrer'
    browser 'User Agent String'
  end
end
