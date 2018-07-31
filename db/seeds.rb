# frozen_string_literal: true

require 'csv'

SignatureType.find_or_create_by! name: 'applicant'
SignatureType.find_or_create_by! name: 'witness'

['brenda.wallace', 'dana.iti'].each do |name|
  email = "#{name}@dia.govt.nz"
  User.invite! email: email unless User.find_by(email: email)
end
