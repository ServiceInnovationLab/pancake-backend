# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

SignatureType.create! name: 'applicant'
SignatureType.create! name: 'witness'

User.invite! email: 'brenda.wallace@dia.govt.nz'
User.invite! email: 'dana.iti@dia.govt.nz'
