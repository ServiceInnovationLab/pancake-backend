class UserPolicy < ApplicationPolicy
  def update?
    user.roles.include? dia_role
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
