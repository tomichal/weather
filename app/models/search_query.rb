class SearchQuery
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :formatted_address, :string
  attribute :latitude, :float
  attribute :longitude, :float

  validates :formatted_address, presence: true
  validates :latitude, :longitude, presence: true, if: -> { formatted_address.present? }

  def persisted?
    false
  end
end
