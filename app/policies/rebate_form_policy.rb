class RebateFormPolicy < ApplicationPolicy
  def index?
    user.present? && user.council_id.present?
  end
  def show?
    user.present? && user.council_id == record.council_id
  end
  def update?
    !record.fully_signed? && is_dia?
  end

  def destroy?
    !record.fully_signed? && (is_dia? || user.council_id == record.council_id)
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
