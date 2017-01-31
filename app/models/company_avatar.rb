class CompanyAvatar < ActiveRecord::Base
  self.table_name = "company_avatar"
  belongs_to :user

  # has_attached_file :image,:style => {:large => '300x300<',:medium => '300x300>',:thumb => '100x100'},
  #                   :url  =>  ":rails_root/public/assets/company_avatar/image/:id/:style/:basename.:extension",
  #                   :path => ":rails_root/public/assets/company_avatar/image/:id/:style/:basename.:extension"
  # validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  # validates_attachment_size :image, :in => 0.megabytes..1.megabytes
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png",
  :path  => ":rails_root/public/system/:class/:attachment/:style/:filename",
      :url => "/system/:class/:attachment/:style/:filename"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  #has_attached_file :image,:style => {:large => '300x300<',:medium => '300x300>',:thumb => '100x100'},
  #                  :url  =>  ":rails_root/public/assets/avatar/image/:id/:style/:basename.:extension",
  #                  :path => ":rails_root/public/assets/avatar/image/:id/:style/:basename.:extension"
  #validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates_attachment_size :image, :in => 0.megabytes..1.megabytes
end