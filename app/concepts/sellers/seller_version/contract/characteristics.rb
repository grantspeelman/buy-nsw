module Sellers::SellerVersion::Contract
  class Characteristics < Base
    property :number_of_employees, on: :seller_version
    property :corporate_structure, on: :seller_version

    property :start_up,                            on: :seller_version
    property :sme,                                 on: :seller_version
    property :not_for_profit,                      on: :seller_version

    property :regional,                            on: :seller_version

    property :australian_owned,                    on: :seller_version
    property :disability,                          on: :seller_version
    property :female_owned,                        on: :seller_version
    property :indigenous,                          on: :seller_version

    property :no_experience,                       on: :seller_version
    property :local_government_experience,         on: :seller_version
    property :state_government_experience,         on: :seller_version
    property :federal_government_experience,       on: :seller_version
    property :international_government_experience, on: :seller_version

    validation :default do
      required(:seller_version).schema do
        # TODO: These don't currently return a nice human-friendly
        # error message currently
        required(:number_of_employees).
          value(included_in?: SellerVersion.number_of_employees.values)
        required(:corporate_structure).
          value(included_in?: SellerVersion.corporate_structure.values)
        required(:regional).filled(:bool?)
      end
    end
  end
end
