require 'ostruct'

class Sellers::Applications::BaseForm < BaseForm
  include Composition
  model :application

  validation :default do
    configure do
      def any_checked?(value)
        value&.reject(&:blank?)&.any?
      end

      def one_of?(values, list)
        list.all? { |value| value.blank? || values.include?(value) }
      end

      def file?(uploader_class)
        uploader_class.respond_to?(:original_filename) || uploader_class.file
      end

      def in_future?(date)
        date.present? && date > Date.today
      end
    end
  end

  def self.human_attribute_name(attribute_key_name, options = {})
    I18n.t("activemodel.attributes.#{self.to_s.underscore}.#{attribute_key_name}", options)
  end

  def seller_id
    seller.id
  end

  def seller
    self.model[:seller]
  end

  def upload_for(key)
    self.model[:seller].public_send(key)
  end

  # When composing forms from multiple models, Reform assigns error messages to
  # the underlying models, which is no use to the Rails form builder. This
  # overrides the `errors` method to flatten all keys to be at the same level.
  #
  # An extra quirk here is that this method is seemingly invoked multiple times
  # with varying levels of detail. If we parse a early call of the method containing
  # no error messages, the models appear to pass as valid and this isn't invoked
  # again.
  #
  # To handle this, if there are no model-specific error messages, we simply
  # return the original error object from the superclass.
  #
  def errors
    new_errors = Reform::Contract::Errors.new

    new_messages = super.messages.select {|key, value|
      self.model.keys.include?(key) && value.first&.is_a?(Array)
    }

    new_messages.each do |model, errors|
      errors.each do |field, msgs|
        # Support accessing the keys as both strings and symbols, as the form
        # builder seems to require both for all fields to work.
        #
        new_errors.messages[field.to_s] = msgs
        new_errors.messages[field] = msgs
      end
    end

    new_messages.any? ? new_errors : super
  end

  # This Populator is used by multiple forms to handle loading, saving and
  # deletion of child objects.
  #
  NestedChildPopulator = ->(fragment:, collection:, index:, params:, context:, model_klass:, **) {
    id = fragment['id'] || fragment[:id]

    if id.present?
      item = collection.find { |item|
        item.id.to_s == id.to_s
      }

      record = model_klass.find_by(seller_id: context.seller_id, id: fragment['id'])
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

    item ? item : collection.append(model_klass.new(:seller_id => context.seller_id))
  }

end
