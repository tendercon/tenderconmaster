class Avatar < ActiveRecord::Base
  self.table_name = "avatar"
  belongs_to :user

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  #has_attached_file :image,:style => {:large => '300x300<',:medium => '300x300>',:thumb => '100x100'},
  #                  :url  =>  ":rails_root/public/assets/avatar/image/:id/:style/:basename.:extension",
  #                  :path => ":rails_root/public/assets/avatar/image/:id/:style/:basename.:extension"
  #validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates_attachment_size :image, :in => 0.megabytes..1.megabytes
end