# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::CouncilsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/admin/councils').to route_to('admin/councils#index')
    end

    it 'routes to #new' do
      expect(get: '/admin/councils/new').to route_to('admin/councils#new')
    end

    it 'routes to #show' do
      expect(get: '/admin/councils/1').to route_to('admin/councils#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/admin/councils/1/edit').to route_to('admin/councils#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/admin/councils').to route_to('admin/councils#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/admin/councils/1').to route_to('admin/councils#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/admin/councils/1').to route_to('admin/councils#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/admin/councils/1').to route_to('admin/councils#destroy', id: '1')
    end
  end
end
