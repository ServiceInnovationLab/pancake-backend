# frozen_string_literal: true

class RebateFormPolicy < ApplicationPolicy
  def generateqr?
    dia? || same_council?
  end

  def index?
    dia? || same_council?
  end

  def show?
    dia? || same_council?
  end

  def update?
    (dia? || same_council?)
  end

  def destroy?
    (dia? || same_council?) && record.not_signed_state?
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
