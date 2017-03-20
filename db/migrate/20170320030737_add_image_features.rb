class AddImageFeatures < ActiveRecord::Migration
  def change
    add_attachment :feature_pages, :figure_holder
    add_attachment :feature_pages, :figure_holder2
    add_attachment :feature_pages, :figure_holder3
    add_attachment :feature_pages, :figure_holder4
  end
end
