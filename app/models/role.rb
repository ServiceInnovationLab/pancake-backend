# frozen_string_literal: true

class Role < ApplicationRecord
  validates :name, uniqueness: true
  has_and_belongs_to_many :users
end
