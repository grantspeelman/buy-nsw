module Sellers::WaitingSeller::Contract
  class Accept < Reform::Form
    property :password, virtual: true
    property :password_confirmation, virtual: true
  end
end
