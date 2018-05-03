module Forms::ValidationHelper
  extend ActiveSupport::Concern

  included do
    validation :default do
      configure do
        def any_checked?(value)
          value&.reject(&:blank?)&.any?
        end

        def one_of?(values, list)
          list.all? { |value| value.blank? || values.include?(value) }
        end

        def in_list?(list, value)
          value.present? && list.include?(value)
        end

        def file?(uploader_class)
          uploader_class.respond_to?(:original_filename) || uploader_class.file
        end

        def in_future?(date)
          date.present? && date > Date.today
        end

        def max_word_count?(max_word_count, value)
          value.split(' ').size <= max_word_count
        end

        def max_items?(max_items, collection)
          collection.size <= max_items
        end

        def contains?(matching_word, input)
          input.any? {|w| w == matching_word }
        end
      end
    end
  end
end
