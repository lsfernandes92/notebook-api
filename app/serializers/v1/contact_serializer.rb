module V1
  class ContactSerializer < ActiveModel::Serializer
    belongs_to :kind, optional: true do
      link(:related) { v1_contact_kind_url(object.id) }
    end

    has_many :phones do
      link(:related) { v1_contact_phones_url(object.id) }
    end

    has_one :address do
      link(:related) { v1_contact_address_url(object.id) }
    end

    attributes :id, :name, :email, :birthdate

    def attributes(*args)
      hash = super(*args)
      hash[:birthdate] = object.birthdate.to_time.iso8601 unless object.birthdate.blank?
      hash
    end
  end
end
