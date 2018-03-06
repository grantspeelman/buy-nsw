class Sellers::Applications::RecognitionForm < Sellers::Applications::BaseForm
  AccreditationPopulator = -> (options) {
    return RecognitionPopulator.call(options.merge(
      param_key: 'accreditation',
      model_klass: SellerAccreditation,
      context: self,
    ))
  }

  AwardPopulator = -> (options) {
    return RecognitionPopulator.call(options.merge(
      param_key: 'award',
      model_klass: SellerAward,
      context: self,
    ))
  }

  EngagementPopulator = -> (options) {
    return RecognitionPopulator.call(options.merge(
      param_key: 'engagement',
      model_klass: SellerEngagement,
      context: self,
    ))
  }

  AccreditationPrepopulator = ->(_) {
    2.times do
      self.accreditations << SellerAccreditation.new(seller_id: seller_id)
    end
  }

  AwardPrepopulator = ->(_) {
    2.times do
      self.awards << SellerAward.new(seller_id: seller_id)
    end
  }

  EngagementPrepopulator = ->(_) {
    2.times do
      self.engagements << SellerEngagement.new(seller_id: seller_id)
    end
  }

  RecognitionPopulator = ->(fragment:, collection:, index:, param_key:, context:, model_klass:, **) {
    if fragment['id'].present?
      item = collection.find { |item|
        item.id.to_s == fragment['id'].to_s
      }

      record = model_klass.find_by(seller_id: context.seller_id, id: fragment['id'])
    end

    if fragment[param_key].blank?
      if item
        collection.delete(item)
      end

      # Invoke this manually because Reform doesn't seem to delete the record,
      # instead attemtping to zero out the foreign key (which violates the
      # database constraint)
      #
      if record
        record.destroy
      end

      return context.skip!
    end

    item ? item : collection.append(model_klass.new(:seller_id => context.seller_id, param_key => fragment[param_key]))
  }

  collection :accreditations, on: :seller, prepopulator: AccreditationPrepopulator, populator: AccreditationPopulator do
    property :accreditation
  end

  collection :awards, on: :seller, prepopulator: AwardPrepopulator, populator: AwardPopulator do
    property :award
  end

  collection :engagements, on: :seller, prepopulator: EngagementPrepopulator, populator: EngagementPopulator do
    property :engagement
  end
end
