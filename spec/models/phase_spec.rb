# Copyright (c) Universidade Federal Fluminense (UFF).
# This file is part of SAPOS. Please, consult the license terms in the LICENSE file.

require "spec_helper"

describe Phase do
  it { should be_able_to_be_destroyed }
  it { should restrict_destroy_when_exists :accomplishment }
  it { should restrict_destroy_when_exists :deferral_type }
  it { should destroy_dependent :phase_duration }

  let(:phase) { Phase.new }
  subject { phase }
  describe "Validations" do
    describe "name" do
      context "should be valid when" do
        it "name is not null and is not taken" do
          phase.name = "Phase name"
          expect(phase).to have(0).errors_on :name
        end
      end
      context "should have error blank when" do
        it "name is null" do
          phase.name = nil
          expect(phase).to have_error(:blank).on :name
        end
      end
      context "should have error taken when" do
        it "name is already in use" do
          name = "Phase name"
          FactoryBot.create(:phase, :name => name)
          phase.name = name
          expect(phase).to have_error(:taken).on :name
        end
      end
    end

    describe "active" do
      context "should be valid when" do
        it "active value is true" do
          phase.name = true
          expect(phase).to have(0).errors_on :active
        end
        it "active value is false" do
          phase.name = false
          expect(phase).to have(0).errors_on :active
        end
      end

      context "should be invalid when" do
        it "active is null" do
          phase.active = nil
          expect(phase).to have(1).errors_on :active
        end
      end
    end
  end

  describe "Class methods" do
    describe "find_all_for_enrollment" do
      it "should return all phases if enrollment is nil" do
        FactoryBot.create(:phase)
        FactoryBot.create(:phase)
        FactoryBot.create(:phase)
        
        phases = Phase.where(Phase::find_all_for_enrollment(nil))
        expect(phases.count).to eq(Phase.count)
      end

      it "should return phases that have the same level as the enrollment" do
        level1 = FactoryBot.create(:level)
        level2 = FactoryBot.create(:level)
        
        phase1 = FactoryBot.create(:phase)
        FactoryBot.create(:phase_duration, :phase => phase1, :level => level1)
          
        phase2 = FactoryBot.create(:phase)
        FactoryBot.create(:phase_duration, :phase => phase2, :level => level1)
          
        phase3 = FactoryBot.create(:phase)
        FactoryBot.create(:phase_duration, :phase => phase3, :level => level2)
         
        enrollment = FactoryBot.create(:enrollment, :level => level1) 
        
        phases = Phase.where(Phase::find_all_for_enrollment(enrollment))
        expect(phases.count).to eq(2)
      end

      it "should not return an inactivated phase if enrollment is nil" do
        Deferral.destroy_all
        DeferralType.destroy_all
        Accomplishment.destroy_all
        Phase.destroy_all
        FactoryBot.create(:phase, :active => false)
        phases = Phase.where(Phase::find_all_for_enrollment(nil))
        expect(phases.count).to eq(0)
      end

      it "should not return an inactivated phase that have the same level as the enrollment" do
        Deferral.destroy_all
        DeferralType.destroy_all
        Accomplishment.destroy_all
        Phase.destroy_all
        level1 = FactoryBot.create(:level)
        
        phase1 = FactoryBot.create(:phase, :active => false)
        FactoryBot.create(:phase_duration, :phase => phase1, :level => level1)

        enrollment = FactoryBot.create(:enrollment, :level => level1)

        phases = Phase.where(Phase::find_all_for_enrollment(enrollment))
        expect(phases.count).to eq(0)
      end

    end
  end
end
