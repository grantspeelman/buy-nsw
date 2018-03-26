require 'rails_helper'

RSpec.describe SellerApplicationPresenter do

  let(:application) { double('SellerApplication') }
  let(:presenter) { SellerApplicationPresenter.new(application) }

  def stub_steps(*steps)
    allow(SellerApplicationStepPresenter).to receive(:steps).and_return(steps)
  end

  context 'given a current step' do
    let(:current_step) {
      double('Step', key: 'key', slug: 'slug', form: double('form'))
    }
    let(:presenter) {
      SellerApplicationPresenter.new(application, current_step_slug: 'slug')
    }

    before { stub_steps(current_step) }

    context '#current_step_key' do
      it 'returns the current step key' do
        expect(presenter.current_step_key).to eq(current_step.key)
      end
    end

    context '#current_step_form' do
      it 'returns the current step form' do
        expect(presenter.current_step_form).to eq(current_step.form)
      end
    end

    context '#current_step_name' do
      it 'returns the current step name' do
        allow(current_step).to receive(:name).with(:long).and_return('Name')

        expect(presenter.current_step_name).to eq('Name')
      end
    end

    context '#current_step_view_path' do
      it 'builds the view path for the current step' do
        expect(presenter.current_step_view_path).to eq('key_form')
      end
    end

    context '#current_step_button_label' do
      it 'returns the button label for the current step, with a default value' do
        allow(current_step).to receive(:button_label).with(default: 'Foo').and_return('Label')

        expect(presenter.current_step_button_label(default: 'Foo')).to eq('Label')
      end
    end
  end

  context '#ready_for_submission?' do
    it 'is true when all steps are valid' do
      stub_steps(
        double('Step', valid?: true),
        double('Step', valid?: true),
        double('Step', valid?: true),
      )

      expect(presenter.ready_for_submission?).to be_truthy
    end

    it 'is true when all steps apart from the last are valid' do
      stub_steps(
        double('Step', valid?: true),
        double('Step', valid?: true),
        double('Step', valid?: false),
      )

      expect(presenter.ready_for_submission?).to be_truthy
    end

    it 'is false when an earlier step is invalid' do
      stub_steps(
        double('Step', valid?: true),
        double('Step', valid?: false),
        double('Step', valid?: true),
      )

      expect(presenter.ready_for_submission?).to be_falsey
    end
  end

  context '#valid?' do
    it 'is true when all steps are valid' do
      stub_steps(
        double('Step', valid?: true),
        double('Step', valid?: true),
        double('Step', valid?: true),
      )

      expect(presenter.valid?).to be_truthy
    end

    it 'is false when at least one step is invalid' do
      stub_steps(
        double('Step', valid?: true),
        double('Step', valid?: false),
        double('Step', valid?: true),
      )

      expect(presenter.valid?).to be_falsey
    end
  end

  context '#first_step_path' do
    it 'returns the path of the first step' do
      stub_steps(
        double('Step', path: '/first_step'),
        double('Step', path: '/last_step'),
      )

      expect(presenter.first_step_path).to eq('/first_step')
    end
  end

  context '#last_step?' do
    before do
      stub_steps(
        double('Step', slug: 'first'),
        double('Step', slug: 'last'),
      )
    end

    it 'returns true when the current step is the last' do
      presenter = SellerApplicationPresenter.new(application, current_step_slug: 'last')

      expect(presenter.last_step?).to be_truthy
    end

    it 'returns false when the current step is not last' do
      presenter = SellerApplicationPresenter.new(application, current_step_slug: 'first')

      expect(presenter.last_step?).to be_falsey
    end
  end

  context '#next_step' do
    before do
      stub_steps(
        double('Step', slug: 'first'),
        double('Step', slug: 'second'),
        double('Step', slug: 'third'),
      )
    end

    it 'returns the next step' do
      presenter = SellerApplicationPresenter.new(application, current_step_slug: 'first')

      expect(presenter.next_step.slug).to eq('second')
    end

    it 'returns the first step when the next step does not exist' do
      presenter = SellerApplicationPresenter.new(application, current_step_slug: 'third')

      expect(presenter.next_step.slug).to eq('first')
    end
  end

  context '#next_step_path' do
    before do
      stub_steps(
        double('Step', slug: 'first'),
        double('Step', slug: 'second', path: '/second'),
      )
    end

    it 'returns the path of the next step' do
      presenter = SellerApplicationPresenter.new(application, current_step_slug: 'first')

      expect(presenter.next_step_path).to eq('/second')
    end
  end

end
