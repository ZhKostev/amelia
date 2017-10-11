class Visitor < ApplicationRecord
  has_many :tag_searches
  has_many :tags, through: :tag_searches
end