# frozen_string_literal: true

class Idea < ApplicationRecord
  belongs_to :user
  belongs_to :assigned_user, class_name: 'User', optional: true
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy

  validates :title, presence: true
  validates :area_of_interest, presence: true, if: :submitted?
  validates :business_area, presence: true, if: :submitted?
  validates :it_system, presence: true, if: :submitted?
  validates :idea, presence: true, if: :submitted?
  validates :benefits, presence: true, if: :submitted?
  validates :impact, presence: true, if: :submitted?
  validates :involvement, presence: true, if: :submitted?
  after_update :send_assigned_user_email

  include Votable

  def submitted?
    submission_date.present?
  end

  def approved_by_admin?
    return false if awaiting_approval? || draft?

    true
  end

  enum benefits: %i[
    better_decision_making
    improved_reputation
    reduced_risk
    time_saved
    cost
    improved_service
    staff_engagement_and_moral
  ]

  enum it_system: %i[
    cclf
    ccms
    ccr
    cis
    cwa
    eforms
    laa_online_portal
    maat
    maat_libra
    management_information
    obiee
    pims
    tv
  ]

  enum involvement: %i[
    i_want_to_be_informed
    i_want_to_be_involved
    i_want_to_lead_on_this
    no_involvement
  ]

  enum business_area: %i[
    exceptional_and_complex_cases
    crime
    civil
    delivery_cm_other
    central_commissioning
    public_defender_service
    service_development
    contract_management
    cla
    digital
    assurance
    finance
    planning_and_performance
    ceo_office
    communications
    operational_change_and_improvement
    engagement_and_inclusion
    corporate_centre_correspondence
    central_legal
  ]

  enum area_of_interest: %i[
    equality_and_diversity
    it_development
    learning_and_development
    my_business_area
    my_office
    other_business_area
    staff_engagement
  ]

  enum status: {
    draft: 0,
    awaiting_approval: 1,
    approved: 2,
    investigation: 3,
    implementing: 4,
    interim_benefits: 5,
    benefits_realised: 6,
    not_proceeding: 7
  }

  enum participation_level: %i[
    assist
    lead
  ]

  private

  def send_assigned_user_email
    IdeaMailer.assigned_idea_email_template(assigned_user, self).deliver_now if saved_change_to_assigned_user_id?
  end
end
