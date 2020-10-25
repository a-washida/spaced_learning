class CategorySecond < ApplicationRecord
  has_many :shares
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category_first
end
