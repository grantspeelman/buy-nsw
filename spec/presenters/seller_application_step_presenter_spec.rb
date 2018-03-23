require 'rails_helper'

RSpec.describe SellerApplicationStepPresenter do

  let(:application) { create(:seller_application) }
  let(:form_klass) { Sellers::Applications::BusinessDetailsForm }

  subject { SellerApplicationStepPresenter.new(application, form_klass) }

  context '.forms' do
    it 'returns a list of forms given an application' do
      forms = SellerApplicationStepPresenter.forms(application)

      expect(forms.size).to eq(9)
      expect(forms.first.ancestors).to include(Sellers::Applications::BaseForm)
    end

    it 'includes the services form when an industry is present' do
      application.seller.industry = ['ict']
      forms = SellerApplicationStepPresenter.forms(application)

      expect(forms.size).to eq(10)
      expect(forms).to include(Sellers::Applications::ServicesForm)
    end

    it 'includes the products form when an industry and a service are present' do
      application.seller.industry = ['ict']
      application.seller.services = ['cloud-services']

      forms = SellerApplicationStepPresenter.forms(application)

      expect(forms.size).to eq(11)
      expect(forms).to include(Sellers::Applications::ProductsForm)
    end
  end

  context '.steps' do
    it 'returns step presenters for each form' do
      steps = SellerApplicationStepPresenter.steps(application)

      expect(steps.first).to be_a(SellerApplicationStepPresenter)
    end
  end

  context '.find_by_key' do
    it 'returns a presenter which matches the provided key' do
      step = SellerApplicationStepPresenter.find_by_key(application, 'contacts')

      expect(step).to be_a(SellerApplicationStepPresenter)
      expect(step.key).to eq('contacts')
    end

    it 'raises a NotFound exception when a matching step does not exist' do
      expect {
        SellerApplicationStepPresenter.find_by_key(application, 'blah')
      }.to raise_error(SellerApplicationStepPresenter::NotFound)
    end
  end

  context '.find_by_slug' do
    it 'returns a presenter which matches the provided slug' do
      step = SellerApplicationStepPresenter.find_by_slug(application, 'contacts')

      expect(step).to be_a(SellerApplicationStepPresenter)
      expect(step.key).to eq('contacts')
    end

    it 'raises a NotFound exception when a matching step does not exist' do
      expect {
        SellerApplicationStepPresenter.find_by_slug(application, 'blah')
      }.to raise_error(SellerApplicationStepPresenter::NotFound)
    end
  end

  context '#form' do
    it 'returns an instantiated form object' do
      form = subject.form

      expect(form).to be_a(form_klass)
      expect(form.application).to eq(application)
      expect(form.seller).to eq(application.seller)
    end
  end

  context '#==' do
    it 'treats another step presenter with the same form class as equal' do
      other_step = SellerApplicationStepPresenter.new(application, form_klass)

      expect(subject).to eq(other_step)
    end

    it 'treats another step presenter with a different form class as inequal' do
      other_step = SellerApplicationStepPresenter.new(application, Sellers::Applications::IntroductionForm)

      expect(subject).to_not eq(other_step)
    end
  end

  context '#key' do
    it 'converts parts of the form name to an underscored key' do
      expect(subject.key).to eq('business_details')
    end
  end

  context '#slug' do
    it 'converts parts of the form name to a dasherised slug' do
      expect(subject.slug).to eq('business-details')
    end
  end

  context '#path' do
    it 'returns the step path for the given application' do
      expect(subject.path).to eq(
        "/sellers/applications/#{application.id}/business-details"
      )
    end
  end

  context '#name' do
    it 'returns the translated value for the step name' do
      expect(I18n).to receive(:t).
                      with('sellers.applications.steps.business_details.short').
                      and_return('Response')

      expect(subject.name).to eq('Response')
    end

    it 'returns the translated value for an alternative key' do
      expect(I18n).to receive(:t).
                      with('sellers.applications.steps.business_details.foo').
                      and_return('Response')

      expect(subject.name(:foo)).to eq('Response')
    end
  end

  context '#button_label' do
    it 'returns the translated value for the button label with a fallback' do
      expect(I18n).to receive(:t).
                      with('sellers.applications.steps.business_details.button_label', default: 'Foo').
                      and_return('Response')

      expect(subject.button_label(default: 'Foo')).to eq('Response')
    end
  end

  context '#valid?' do
    it 'invokes the `valid?` method on the form object' do
      expect(subject.form).to receive(:valid?).and_return(true)
      expect(subject.valid?).to be_truthy
    end
  end

  context '#started?' do
    it 'invokes the `started?` method on the form object' do
      expect(subject.form).to receive(:started?).and_return(true)
      expect(subject.started?).to be_truthy
    end
  end
end
