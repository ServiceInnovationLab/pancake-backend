class CouncilPolicy < ApplicationPolicy
  def create?
    is_dia?
  end

  def update?
    is_dia?
  end

  def destroy?
    is_dia? && ! record.rebate_forms.size.positive?
  end

  class Scope < Scope
    def resolve
      if user.present?
        scope.all
      else
        scope.none
      end
    end
  end
end
