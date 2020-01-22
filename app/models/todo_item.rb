class TodoItem
  STATUS = ['Pending', 'Start', 'Finish']

  # Libraries
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  # Document fields and their types
  field :title, type: String
  field :description, type: String
  field :status, type: String, default: 'Pending'

  # Validations
  validates_presence_of :title
  validates :title,  uniqueness: { conditions: -> { where(deleted_at: nil) } }
  validates_inclusion_of :status, in: STATUS, message: "is invalid. Please enter valid status - #{STATUS.join(',')}"

  # Relations with other documents

  # By using `inverse_of: nil`, it will not add `todo_item_ids`
  # in `Tag` Documents
  has_and_belongs_to_many :tags, inverse_of: nil do
    def to_s
       map(&:name).join(",")
    end
  end
end
