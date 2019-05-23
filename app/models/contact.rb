class Contact < ApplicationRecord
  # Kaminari paginates
  paginates_per 5

  belongs_to :kind, optional: true
  has_many :phones
  has_one :address

  accepts_nested_attributes_for :phones, allow_destroy: true
  accepts_nested_attributes_for :address, update_only: true

   def author
    "Lucas Fernandes"
  end

   def as_json(options={})
    super(
      root: true,
      methods: :author,
      except: [:created_at, :updated_at],
      include: {
        kind: { except: [:created_at, :updated_at] },
        phones: { except: [:created_at, :updated_at] },
        address: { except: [:created_at, :updated_at] }
      }
    )
  end
end
