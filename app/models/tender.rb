class Tender < ActiveRecord::Base
  has_one :tender_quote
  has_one :category

  belongs_to :user
  belongs_to :user_tender

  has_many :tender_approved_trades
  has_many :tender_documents
  has_many :tender_sites
  has_many :tender_trades
  has_many :tender_invites
  has_many :document_packages
  has_many :packages
  has_many :package_downloads


  validates :title, presence: { message: "title is required" }
  validates :address, presence: true
  validates :category_id, presence: true


  def self.compressed_document id
    require 'zip'
    tender = Tender.find(id)
    @destination =  "#{Rails.root}/public/assets/tender/#{tender.tendercon_id}"

    t = TenderDocument.where(:tender_id => id)

    if t.present?
      t.each do |r|
        FileUtils.cp_r(("#{Rails.root}/public/assets/tender/document/#{r.id}/"), @destination)
      end
    end

    @destination.sub!(%r[/$],'')

    archive = File.join(@destination,File.basename(@destination))+'.zip'
    FileUtils.rm archive, :force=>true

    Zip::File.open(archive, 'w') do |zipfile|
      Dir["#{@destination}/**/**"].reject{|f|f==archive}.each do |file|
        zipfile.add(file.sub(@destination+'/',''),file)
      end
    end

  end

  def self.compressed_document_matrix path,tender_id,user_id,ip
    require 'zip'
    @destination = path


    @destination.sub!(%r[/$],'')

    archive = File.join(File.dirname(@destination),File.basename(@destination))+'.zip'
    FileUtils.rm archive, :force=>true

    Zip::File.open(archive, 'w') do |zipfile|
      Dir["#{@destination}/**/**"].reject{|f|f==archive}.each do |file|
        zipfile.add(file.sub(@destination+'/',''),file)
      end
    end

    doc_package =  DocumentPackage.where(:url => "http://"+ip+"/assets/tender/document/#{File.basename(archive)}",:path => path,:tender_id => tender_id,:user_id => user_id).first

    if !doc_package.present?
      document_package = DocumentPackage.new
      document_package.tender_id = tender_id
      document_package.user_id = user_id
      document_package.url = "http://"+ip+"/assets/tender/document/#{File.basename(archive)}"
      document_package.path = path
      document_package.save
    end



    tender = Tender.where(:id => tender_id).first
    if tender.present?
      dir = "#{Rails.root}/public/assets/tender/document/Fullset-#{tender.tendercon_id}"

      Dir.mkdir(dir) unless File.exists?(dir)
      FileUtils.cp("public/assets/tender/document/#{File.basename(archive)}", dir)


      archive1 = File.join(File.dirname(dir),File.basename(dir))+'.zip'
      FileUtils.rm archive1, :force=>true

      Zip::File.open(archive1, 'w') do |zipfile|
        Dir["#{dir}/**/**"].reject{|f|f==archive1}.each do |file|
          zipfile.add(file.sub(dir+'/',''),file)
        end
      end

    end



  end



end