# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def update?
    dia?
  end

  def destroy?
    dia? && record.id != user.id
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
