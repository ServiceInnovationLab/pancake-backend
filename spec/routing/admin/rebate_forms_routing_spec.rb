# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::RebateFormsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/admin').to route_to('admin/rebate_forms#index')
    end

    it 'routes to #index' do
      expect(get: '/admin/').to route_to('admin/rebate_forms#index')
    end

    it 'routes to #index' do
      expect(get: '/admin/rebate_forms').to route_to('admin/rebate_forms#index')
    end

    it 'routes to #new' do
      expect(get: '/admin/rebate_forms/new').to route_to('admin/rebate_forms#new')
    end

    it 'routes to #show' do
      expect(get: '/admin/rebate_forms/1').to route_to('admin/rebate_forms#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/admin/rebate_forms/1/edit').to route_to('admin/rebate_forms#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/admin/rebate_forms').to route_to('admin/rebate_forms#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/admin/rebate_forms/1').to route_to('admin/rebate_forms#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/admin/rebate_forms/1').to route_to('admin/rebate_forms#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/admin/rebate_forms/1').to route_to('admin/rebate_forms#destroy', id: '1')
    end
  end
end
