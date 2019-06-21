# frozen_string_literal: true

class RebateFormsCouncilDetailsPolicy < ApplicationPolicy
  def update?
    dia? || same_council?
  end

  class Scope < Scope
    def resolve
      if user.dia?
        scope.all
      elsif user.present?
        scope.joins(:property).where("properties.council_id": user.council_id)
      else
        scope.none
      end
    end
  end
end
