class CreateCompanyPages < ActiveRecord::Migration
  def change
    create_table :company_pages do |t|
      t.text  :headline
      t.text  :intro
      t.string  :team_block
      t.string  :block_heading
      t.text    :block_intro
      t.string  :ceo_name
      t.text  :ceo_title
      t.text  :ceo_linkedin
      t.text  :ceo_instagram
      t.string  :co_founder_name
      t.text  :co_founder_title
      t.text  :co_founder_linkedin
      t.string  :team_name3
      t.string  :team_title3
      t.string  :team_name4
      t.string  :team_title4
      t.string  :team_name5
      t.string  :team_title5
      t.string  :team_name6
      t.string  :team_title6
      t.string  :team_name7
      t.string  :team_title7
      t.string  :team_name8
      t.string  :team_title8
    end
  end
end
