class Ops::WaitingSeller::Update < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step :model!
    step Contract::Build( constant: Ops::WaitingSeller::Contract::Update )
    success :prevalidate!

    def model!(options, params:, **)
      options['model'] = WaitingSeller.created.find(params[:id])
    end

    def prevalidate!(options, params:, **)
      unless params.key?(:waiting_seller)
        options['contract.default'].validate(
          options['model'].attributes
        )
      end
    end
  end

  step Nested(Present)
  step Contract::Validate( key: :waiting_seller )
  step Contract::Persist()
end
