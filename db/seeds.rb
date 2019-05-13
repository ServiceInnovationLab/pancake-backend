# frozen_string_literal: true

require 'csv'

SignatureType.find_or_create_by! name: 'applicant'
SignatureType.find_or_create_by! name: 'witness'

dia_role = Role.find_or_create_by name: 'dia', friendly_name: 'Te Tari Taiwhenua'
rates_team = Role.find_or_create_by name: 'rates', friendly_name: 'Council rates staff'
frontline = Role.find_or_create_by name: 'frontline', friendly_name: 'Council frontline staff'

['brenda.wallace', 'dana.iti'].each do |name|
  email = "#{name}@dia.govt.nz"
  User.invite!(email: email,
               roles: [dia_role]) unless User.find_by(email: email)
end
