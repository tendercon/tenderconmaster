class ProjectAvatar < ActiveRecord::Base
  belongs_to :user
  belongs_to :user

  has_attached_file :image,:style => {:large => '300x300<',:medium => '300x300>',:thumb => '100x100'},
                    :url  =>  ":rails_root/public/assets/project_avatar/image/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/project_avatar/image/:id/:style/:basename.:extension"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates_attachment_size :image, :in => 0.megabytes..2.megabytes
end