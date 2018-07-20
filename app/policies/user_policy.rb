# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def update?
    is_dia?
  end

  def destroy?
    is_dia? && record.id != user.id
  end

  class Scope < Scope
    def resolve
      if user.present?
        scope.all
      else
        scope.where(council_id: user.council_id)
      end
    end
  end
end
