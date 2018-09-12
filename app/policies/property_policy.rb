# frozen_string_literal: true

class PropertyPolicy < ApplicationPolicy
  def create?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end

  class Scope < Scope
    def resolve
      if user.dia?
        scope.all
      elsif user.present? && user.council.present?
        scope.where(council_id: user.council_id)
      else
        scope.none
      end
    end
  end
end
