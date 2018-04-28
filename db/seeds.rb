# frozen_string_literal: true

SignatureType.find_or_create_by! name: 'applicant'
SignatureType.find_or_create_by! name: 'witness'


User.invite! email: 'brenda.wallace@dia.govt.nz'
User.invite! email: 'dana.iti@dia.govt.nz'
