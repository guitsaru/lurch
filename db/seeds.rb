# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

Setting.find_or_create_by_key('jenkins_url')
Setting.find_or_create_by_key('jenkins_user')
Setting.find_or_create_by_key('jenkins_password')

Setting.find_or_create_by_key('campfire_account')
Setting.find_or_create_by_key('campfire_token')

Setting.find_or_create_by_key('github_username')
Setting.find_or_create_by_key('github_password')

Setting.find_or_create_by_key('lurch_url')
