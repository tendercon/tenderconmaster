# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

TenderRequestQuote.delete_all
TenderApprovedTrade.delete_all
TenderInvite.delete_all
Tender.delete_all
TenderQuote.delete_all
TenderDocument.delete_all
OpenTender.delete_all
TenderTrade.delete_all
Package.delete_all
Addenda.delete_all
User.delete_all

user = User.new
user.email = 'agile.jjp@gmail.com'
user.password = "#{Digest::MD5.hexdigest('Admin1234')+Digest::MD5.hexdigest('AdmIn')}"
user.confirmed_password = "#{Digest::MD5.hexdigest('Admin1234')+Digest::MD5.hexdigest('AdmIn')}"
user.verified = true
user.abn = '83959230241'
user.tendercon_id = 'TDF'
user.tendercon_key = '6b7270af66672d5229ff52c3f1d87d2821716da691ac2a98db84e794a653707f'
user.role = 'Head Contractor'
user.first_name = 'Head Contractor'
user.last_name = 'Admin Head Contractor'
user.save
puts "HASH ------->#{Digest::MD5.hexdigest('Admin1234')+Digest::MD5.hexdigest('AdmIn')}"
user1 = User.new
user1.email = 'joe_dhay@yahoo.com'
user1.password = "#{Digest::MD5.hexdigest('Admin1234')+Digest::MD5.hexdigest('AdmIn')}"
user1.confirmed_password = "#{Digest::MD5.hexdigest('Admin1234')+Digest::MD5.hexdigest('AdmIn')}"
user1.verified = true
user1.abn = '83959230242'
user1.tendercon_id = 'TDV'
user1.tendercon_key = '6b7270af66672d5229ff52c3f1d87d2821716da691ac2a98db84e794a653707f'
user1.role = 'Sub Contractor'
user1.first_name = 'Sub Contractor'
user1.last_name = 'Admin Sub Contractor'
user1.save
