# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# TenderRequestQuote.delete_all
# TenderApprovedTrade.delete_all
# TenderInvite.delete_all
# Tender.delete_all
# TenderQuote.delete_all
# TenderDocument.delete_all
# OpenTender.delete_all
# TenderTrade.delete_all
# TenderSite.delete_all
# Package.delete_all
# Addenda.delete_all
# Quote.delete_all
# QuoteDocument.delete_all
# QuoteDocumentOptional.delete_all
# Rfi.delete_all
# RfiDocument.delete_all

# UserPlan.where(:user_id =>6).destroy_all
# user_plan = UserPlan.new
# user_plan.user_id = 6
# user_plan.plan = 'STARTER PLAN $0'
# user_plan.amount = 0.00
# user_plan.save
#
# UserPlan.where(:user_id =>7).destroy_all
# user_plan = UserPlan.new
# user_plan.user_id = 7
# user_plan.plan = 'STARTER PLAN $0'
# user_plan.amount = 0.00
# user_plan.save

@user = User.find(26)#.update_all(:password => (User.rehash_password 'Admin1234'))
puts "@=======> #{@user.inspect}"
User.where(:id => 26).update_all(:password => (User.rehash_password 'Admin1234'), :status => nil)


#User.where(:email => 'joe_dhay@yahoo.com').update_all(:role_type => 'role_type')


# for i in 0..1997
#   characters = ('A'..'Z').to_a
#
#   new_code = (0..2).map{characters.sample}.join
#
#   puts new_code
#
#   tendercon_code = TenderconCode.where(:name => new_code).first
#
#   puts tendercon_code.inspect
#
#   if !tendercon_code.present?
#
#     tendercon = TenderconCode.new
#     tendercon.name = new_code
#     tendercon.save
#
#   end
#
# end
#
#
#
# ['Architect','Construction Manager','Contract Administrator','Director','Engineer','Estimating Manager',
# 'Estimator','Project Manager','Site Manager','Surveyor'].each do |t|
#   position = Position.new
#   position.title = t
#   position.save
#
# end
#
#
#
# ['0900-0930','0930-1000','1000-1030','1030-1100','1100-1130','1130-1200','1200-1230','1230-1300','1300-1330',
# '1330-1400','1400-1430','1430-1500','1500-1530','1530-1600','1600-1630','1630-1700','1700-1730','1730-1800',
# '1800-1830','1830-1900'].each do |t|
#   time = TimeAvailability.new
#   time.availability = t
#   time.save
# end
#
# ['Asbestos','Civil Works','Asphalt Roads & Driveways','Cranes','Demolition','Earthworks','Scaffold','Shoring','Shotcrete','Building Cleaners','Fencing',
# 'Hoarding','Awnings','Bricklayers','Blocklayers','Carpentry','Concrete','Concrete Cutting','Concrete Repair','Formwork','Light Steel Framing','Piling',
# 'Precast Concrete','Reinforcement','Structural Steel','Timber Framing','Timber Trusses','Waterproofing','Swimming Pools','Access Floors','Air Grilles / Louvres',
# 'Aluminium Windows','Balustrading','Blinds & Curtains','Carpet','Vinyl','Caulking','Ceilings','Doors & Frames','Double Glazing','Epoxy Floor Coatings','Facade Construction',
# 'Glazed Balustrades','Glaziers','Hardware','Insulation','Joinery','Linemarking','Marble / Granite','Metalwork','Painting','Plasterboard Partitions','Paving','Resilient Flooring',
# 'Roller Doors','Roof Tiling','Roofing','Sanitary Hardware','Security Screens','Signs / Displays','Solid Plaster / Render','Stainless Steel','Stairs','Tactile Indicators','Tiling',
# 'Timber Flooring','Timber Windows','Toilet Partitions','Workstations','Window Film','Operable Walls','Pinboards & Whiteboards','Glazed Partitions','Furniture (Commercial)','Landscaping',
# 'Whitegoods','Water Tanks','Skylights','Coolrooms','Access Control','Audiovisual','CCTV','Communications','Electrical Services','Fire Services','Floor Heating','Hydraulic Services','Intercoms',
# 'Lift Services','Mechanical Services','Security','Solar Panels'].each do |t|
#
#   trade = Trade.where(:name => t)
#
#   if !trade.present?
#     new_trade = Trade.new
#     new_trade.name = t
#     new_trade.save
#   end
#
# end
#
# Position.delete_all
#
# ['Architect','Construction Manager','Contract Administrator','Director','Engineer','Estimating Manager',
# 'Estimator','Project Manager','Site Manager','Surveyor'].each do |t|
#   position = Position.new
#   position.title = t
#   position.save
#
# end
#
# # ["Joener's Building","Prime Form Constructions","Ryan Building Services","Sandro Botic Constructions Pty Ltd"].each do |a|
# #   company = Company.where(:name => a).first
# #
# #   if company.present?
# #     Company.where(:id => company.id).destroy_all
# #   end
# # end
#
# ['Civil','Commercial','Community','Defence','Education','Environmental','Goverment','Industrial',
# 'Infrastructure','Institutional','Medical','Residential','Retail','Aged Care/Retirement','Aviation',
# 'Energy and Resources','Sports','Camps and Accommadation','Oil and Gas','Transport','Development'].each do |c|
#   category = Category.new
#   category.name = c
#   category.save
#
# end
#
#
#
# ['1K - 10K','10K - 50K','50K - 100K','100K - 250K','250K - 500K','500K - 1M',
# '1M - 5M','5M - 10M','10M - 20M','20M - 50M','50M - 100M','100M - 500M','500M + '].each do |a|
#   tender_value = TenderValue.new
#
#   tender_value.range = a
#   tender_value.save
# end
#
# ['Preliminaries','Structural','Architectural','Services'].each do |a|
#   trade_categories = TradeCategory.new
#   trade_categories.title = a
#   trade_categories.save
# end
#
#
# ['Asbestos',
# 'Civil Works',
# 'Asphalt Roads & Driveways',
# 'Cranes',
# 'Demolition',
# 'Earthworks',
# 'Scaffold',
# 'Shoring',
# 'Shotcrete',
# 'Building Cleaners',
# 'Fencing',
# 'Hoarding'].each do |t|
#    Trade.where(:name => t).update_all(:trade_category_id => 1)
# end
#
#
# ['Awnings',
# 'Bricklayers',
# 'Blocklayers',
# 'Carpentry',
# 'Concrete',
# 'Concrete Cutting',
# 'Concrete Repair',
# 'Formwork',
# 'Light Steel Framing',
# 'Piling',
# 'Precast Concrete',
# 'Reinforcement',
# 'Structural Steel',
# 'Timber Framing',
# 'Timber Trusses',
# 'Waterproofing',
# 'Swimming Pools'
# ].each do |t|
#   Trade.where(:name => t).update_all(:trade_category_id => 2)
# end
#
# ['Access Floors',
# 'Air Grilles / Louvres',
# 'Aluminium Windows',
# 'Balustrading',
# 'Blinds & Curtains',
# 'Carpet',
# 'Vinyl',
# 'Caulking',
# 'Ceilings',
# 'Doors & Frames',
# 'Double Glazing',
# 'Epoxy Floor Coatings',
# 'Facade Construction',
# 'Glazed Balustrades',
# 'Glaziers',
# 'Hardware',
# 'Insulation',
# 'Joinery',
# 'Linemarking',
# 'Marble / Granite',
# 'Metalwork',
# 'Painting',
# 'Plasterboard Partitions',
# 'Paving',
# 'Resilient Flooring',
# 'Roller Doors',
# 'Roof Tiling',
# 'Roofing',
# 'Sanitary Hardware',
# 'Security Screens',
# 'Signs / Displays',
# 'Solid Plaster / Render',
# 'Stainless Steel',
# 'Stairs',
# 'Tactile Indicators',
# 'Tiling',
# 'Timber Flooring',
# 'Timber Windows',
# 'Toilet Partitions',
# 'Workstations',
# 'Window Film',
# 'Operable Walls',
# 'Pinboards & Whiteboards',
# 'Glazed Partitions',
# 'Furniture (Commercial)',
# 'Landscaping',
# 'Whitegoods',
# 'Water Tanks',
# 'Skylights',
# 'Coolrooms'].each do |t|
#   Trade.where(:name => t).update_all(:trade_category_id => 3)
# end
#
# ['Access Control',
# 'Audiovisual',
# 'CCTV',
# 'Communications',
# 'Electrical Services',
# 'Fire Services',
# 'Floor Heating',
# 'Hydraulic Services',
# 'Intercoms',
# 'Lift Services',
# 'Mechanical Services',
# 'Security',
# 'Solar Panels'
# ].each do |t|
#   Trade.where(:name => t).update_all(:trade_category_id => 4)
# end
#
# ['Others'].each do |a|
#   trade_categories = TradeCategory.new
#   trade_categories.title = a
#   trade_categories.save
# end



