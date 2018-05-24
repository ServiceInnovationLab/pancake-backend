# frozen_string_literal: true

class Note < ApplicationRecord
  belongs_to :rebate_form
  belongs_to :user
end
