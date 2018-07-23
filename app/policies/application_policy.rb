# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  private

  # User is in the same council as the record
  def same_council?
    user.present? && user.council.present? && record.council.present? && user.council_id == record.council.id
  end

  def dia?
    user.present? && user.roles.include?(dia_role)
  end

  def dia_role
    Role.find_by(name: 'dia')
  end
end
