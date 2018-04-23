module Concerns::Contracts::Populators
  extend ActiveSupport::Concern

  NestedChildPopulator = ->(fragment:, collection:, index:, params:, context:, model_klass:, foreign_key:, **) {
    id = fragment['id'] || fragment[:id]

    if id.present?
      item = collection.find { |item|
        item.id.to_s == id.to_s
      }

      record = model_klass.find_by(foreign_key => context.send(foreign_key), id: fragment['id'])
    end

    values = fragment.slice(*params).reject {|k,v| v.blank? }

    if values.empty?
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

    item ? item : collection.append(model_klass.new(foreign_key => context.send(foreign_key)))
  }
end
