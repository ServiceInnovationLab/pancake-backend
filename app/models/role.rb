# frozen_string_literal: true

class Role < ApplicationRecord
  validates :name, uniqueness: true
  has_many :users, dependent: :destroy
end
