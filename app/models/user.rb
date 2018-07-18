# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_paranoid column: :deactivated_at
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :invitable, :lockable
end
