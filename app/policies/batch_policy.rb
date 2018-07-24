# frozen_string_literal: true

class BatchPolicy < ApplicationPolicy
  def index?
    dia? || same_council?
  end

  def show?
    dia? || same_council?
  end

  def create?
    dia? || same_council?
  end

  def update?
    (dia? || same_council?) && !record.fully_signed?
  end

  def destroy?
    (dia? || same_council?) && !record.fully_signed?
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
