RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller

  config.before(:each, type: :controller) do |example|
    if factory = example.metadata[:sign_in]
      @user = create(factory)
      sign_in @user
    end
  end
end
