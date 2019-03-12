# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Idea < ApplicationRecord
  include ReviewDate
  include Votable
  belongs_to :user
  belongs_to :assigned_user, class_name: 'User', optional: true
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :benefits, dependent: :destroy, autosave: true

  validates :title, presence: true
  validates :area_of_interest, presence: true, if: :submitted?
  validates :business_area, presence: true, if: :submitted?
  validates :it_system, presence: true, if: :submitted?
  validates :idea, presence: true, if: :submitted?
  validates :benefits, presence: true, if: :submitted?
  validates :impact, presence: true, if: :submitted?
  validates :involvement, presence: true, if: :submitted?
  validates :review_date, future: true
  before_validation :update_review_date
  after_update :send_update_notifications

  default_scope { order(:submission_date) }
  scope :approved_or_beyond, -> { where.not(status: [:awaiting_approval, :draft]) }
  scope :allocated_ideas, ->(user) { where('assigned_user_id = ?', user) }
  scope :my_ideas, ->(user) { where('user_id = ?', user) }
  scope :review, -> { unscoped.where(status: [:approved, :investigation, :implementing, :interim_benefits]).order(:review_date) }

  def submitted?
    submission_date.present?
  end

  def approved_by_admin?
    return false if awaiting_approval? || draft?

    true
  end

  def proceeding?
    return false if not_proceeding? || draft?

    true
  end

  def benefit_list=(incoming_benefits)
    remove_benefit_if_necessary incoming_benefits
    add_new_benefits incoming_benefits
  end

  def benefit?(benefit)
    benefits.exists?(benefit: benefit)
  end

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

  def send_update_notifications
    IdeaMailer.assigned_idea_email_template(assigned_user, self).deliver_now if saved_change_to_assigned_user_id?

    IdeaMailer.status_change_email_template(User.find(user_id), self).deliver_now if saved_change_to_status?
  end

  def remove_benefit_if_necessary(incoming_benefits)
    benefits.each do |benefit|
      benefit.destroy unless incoming_benefits.map(&:to_s).include?(benefit.benefit)
    end
    benefits.reload
  end

  def add_new_benefits(incoming_benefits)
    incoming_benefits.each do |benefit|
      if new_record?
        benefits << Benefit.new(benefit: benefit) unless benefit? benefit
      else
        benefits.find_or_create_by!(benefit: benefit)
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
