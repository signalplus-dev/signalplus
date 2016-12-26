require 'rails_helper'

describe SubscriptionPlan do
  let(:basic_plan)    { SubscriptionPlan.basic }
  let(:advanced_plan) { SubscriptionPlan.advanced }
  let(:premium_plan)  { SubscriptionPlan.premium }

  describe '#{plan_name}?' do
    describe '#basic?' do
      context 'basic plan' do
        subject { basic_plan }
        it { is_expected.to be_basic }
      end

      context 'advanced plan' do
        subject { advanced_plan }
        it { is_expected.to_not be_basic }
      end

      context 'premium plan' do
        subject { premium_plan }
        it { is_expected.to_not be_basic }
      end
    end

    describe '#advanced?' do
      context 'basic plan' do
        subject { basic_plan }
        it { is_expected.to_not be_advanced }
      end

      context 'advanced plan' do
        subject { advanced_plan }
        it { is_expected.to be_advanced }
      end

      context 'premium plan' do
        subject { premium_plan }
        it { is_expected.to_not be_advanced }
      end
    end

    describe '#premium?' do
      context 'basic plan' do
        subject { basic_plan }
        it { is_expected.to_not be_premium }
      end

      context 'advanced plan' do
        subject { advanced_plan }
        it { is_expected.to_not be_premium }
      end

      context 'premium plan' do
        subject { premium_plan }
        it { is_expected.to be_premium }
      end
    end
  end
end
