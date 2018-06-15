module AccessibleHintComponent
  include SimpleForm::Components::Hints

  def accessible_hint(wrapper_options={})
    if hint_exists?
      @builder.hint(hint_text, hint_tag: wrapper_options[:tag], class: wrapper_options[:class], id: hint_id)
    end
  end

  def hint_exists?
    hint_text.present?
  end

  def hint_id
    input_html_options[:aria][:described_by]
  end

  def hint_text
    input_options[:hint]
  end
end
SimpleForm.include_component(AccessibleHintComponent)
