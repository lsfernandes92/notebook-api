class Contact < ApplicationRecord
  belongs_to :kind, optional: true

   def author
    "Lucas Fernandes"
  end

   def as_json(options={})
    super(
      root: true,
      methods: :author,
      except: [:created_at, :updated_at],
      include: { kind: { except: [:created_at, :updated_at] } }
    )
  end
end
