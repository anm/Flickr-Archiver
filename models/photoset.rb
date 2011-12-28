class Photoset
  include DataMapper::Resource
  property :id, Serial

  belongs_to :user
  has n, :photos, :through => Resource

  property :flickr_id, String, :length => 50, :index => true

  property :title, String, :length => 100
  property :description, Text
  property :secret, String, :length => 50

  property :created_date, DateTime  # from Flickr
  property :updated_date, DateTime  # from Flickr

  # Returns the relative link to this item's page on this website
  def page(photo=nil)
    "/#{self.user.username}/set/#{self.id}/#{self.title_urlsafe}" + (photo.nil? ? "" : "?show=#{photo.id}")
  end

  def title_urlsafe
    self.title.gsub(/[^A-Za-z0-9_-]/, '-')
  end

  def self.create_from_flickr(obj, user)
    set = Photoset.new
    set.user = user
    set.flickr_id = obj.id
    set.title = obj.title
    set.secret = obj.secret
    set
  end
end