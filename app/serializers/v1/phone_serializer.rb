module V1
  class PhoneSerializer < ActiveModel::Serializer
    attributes :id, :number

    belongs_to :contact do
      link(:related) { v1_contact_url(object.contact.id) }
    end
  end
end
