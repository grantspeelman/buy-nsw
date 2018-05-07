module Shared::Predicates
  include Dry::Logic::Predicates

  predicate(:email?) do |value|
    value.match?(URI::MailTo::EMAIL_REGEXP)
  end
end
