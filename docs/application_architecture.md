# Application architecture

### Seller onboarding workflow

*TODO: This section is out of date and requires updating*

The seller onboarding flow is a multi-step form, which goes beyond Rails'
typical CRUD-idioms.

In this app, the flow is implemented with the `SellerApplicationPresenter`,
using form objects to model each step. The form objects use the
[Reform](http://trailblazer.to/gems/reform/) gem, part of the
[Trailblazer](http://trailblazer.to) framework. Reform has some intricacies
around dealing with composition (eg. the `Seller` and `SellerApplication`
models) and nested fields, for which overrides are defined in
`Sellers::Applications::BaseForm`.

Each form defines its own validations, which use the
[dry-validation](http://dry-rb.org/gems/dry-validation/) library. No validations
are defined directly on the model, because objects should only be persisted
through a form object.

This is important because:
- we can save an incomplete record (eg. so that a seller can save their
  application and return later).
- we can vary the steps displayed to the user based on the information provided,
  and only validate data corresponding to the steps which are shown.

The forms for the application are defined in `app/forms/sellers/applications/`,
with associated views in `app/views/sellers/applications/`, and most of the form
strings in the `en` locale file.
