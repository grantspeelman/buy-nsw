module AccessibleErrorComponent
  include SimpleForm::Components::Errors

  def accessible_error(wrapper_options={})
    @builder.error(attribute_name, id: options[:error_id])
  end
end
SimpleForm.include_component(AccessibleErrorComponent)
