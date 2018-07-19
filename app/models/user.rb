# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_paranoid column: :deactivated_at
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :invitable, :lockable

  has_and_belongs_to_many :roles

  belongs_to :council, required: false
end
