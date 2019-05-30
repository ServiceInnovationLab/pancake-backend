# frozen_string_literal: true

class ProcessRebateFormsPolicy < ApplicationPolicy
  def create?
    dia? || same_council?
  end

  def destroy?
    dia? || same_council?
  end

  def destroy_all?
    dia? || same_council?
  end

  class Scope < Scope
    def resolve
      if user.dia?
        scope.all
      elsif user.council_id.present?
        scope.where(council_id: user.council_id)
      else
        scope.none
      end
    end
  end
end
