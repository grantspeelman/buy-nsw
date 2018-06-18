class FormErrorDecorator < BaseDecorator
  def messages
    friendly_format_messages(super)
  end

  def [](name)
    messages[name] || []
  end

private
  def friendly_format_messages(messages)
    tuples = messages.map {|key, messages|
      formatted = messages.yield_self(&method(:remove_blank_messages)).
                           yield_self(&method(:downcase_other_messages)).
                           yield_self(&method(:limit_politeness))
      [key, formatted]
    }
    Hash[tuples]
  end

  def remove_blank_messages(messages)
    messages.reject {|msg|
      msg.blank?
    }
  end

  def downcase_other_messages(messages)
    if messages.size > 1
      messages[1..-1].each(&:downcase!)
    end
    messages
  end

  def limit_politeness(messages)
    if messages.size > 1
      messages[1..-1].each {|msg|
        msg.gsub!(/please/i, '')
      }
    end
    messages
  end
end
