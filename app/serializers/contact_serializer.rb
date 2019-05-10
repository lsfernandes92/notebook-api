class ContactSerializer < ActiveModel::Serializer
  belongs_to :kind, optional: true do
    link(:related) { contact_kind_url(object.id) }
  end
  has_many :phones
  has_one :address

  attributes :id, :name, :email, :birthdate

  def attributes(*args)
    hash = super(*args)
    hash[:birthdate] = object.birthdate.to_time.iso8601 unless object.birthdate.blank?
    hash
  end
end
