class Tag < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :tag_searches

  before_validation :clear_name

  private

  def clear_name
    self[:name] = self[:name].to_s.gsub(/#|\W|/, '')
  end
end
