class Exam < ApplicationRecord
  belongs_to :subject
  has_many :registrations
  has_many :users, through: :registrations
  has_many :questions
  has_many :exam_performances
  
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name "exams_#{Rails.env}"
  
  settings do
    mappings dynamic: 'false' do
      # Define the mappings for your Exam model attributes
      indexes :exam_name, type: 'text'
      indexes :start_time, type: 'date'
      indexes :duration, type: 'integer'
      # Add more mappings as needed
    end
  end
  def self.search_by_exam_name(search_term)
    search_definition = {
      query: {
        prefix: {
          exam_name: search_term.downcase
        }
      }
    }
    __elasticsearch__.search(search_definition).records
  end
  def self.filter_by_department(department)
    where(department: department)
  end

  def self.filter_by_subject(subject)
    where(subject: subject)
  end
  after_commit lambda { __elasticsearch__.index_document }, on: [:create, :update]
  after_commit lambda { __elasticsearch__.delete_document }, on: :destroy
end