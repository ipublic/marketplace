FactoryBot.define do
  factory :wages_wage_entry, class: 'Wages::WageEntry' do
    
    submission_kind		{ :original }
    submitted_at			{ Time.now }

    trait :original_submission do
      submission_kind { :original }
    end

    trait :ammended_submission do
      submission_kind { :ammended }
    end

  end
end
