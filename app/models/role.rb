# frozen_string_literal: true

class Role < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  validates :friendly_name, uniqueness: true, presence: true
  has_and_belongs_to_many :users
end
