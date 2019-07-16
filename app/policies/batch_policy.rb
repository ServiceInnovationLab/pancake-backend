# frozen_string_literal: true

class BatchPolicy < ApplicationPolicy
  def index?
    read?
  end

  def show?
    read?
  end

  def create?
    write?
  end

  def update?
    write?
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

  private

  # Unified permission for reading records (Index, Show)
  def read?
    dia? || same_council?
  end

  # Unified permission for write operations (Create, Update - Delete is not
  # supported in this policy)
  def write?
    # DIA users are not allowed to create batches because they can view records
    # from multiple councils simultaneously
    same_council? && !dia?
  end
end
