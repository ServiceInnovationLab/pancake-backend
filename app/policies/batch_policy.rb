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
