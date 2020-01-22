class Tag
  # Libraries
  include Mongoid::Document
  include Mongoid::Timestamps

  # Document fields and their types
  field :name, type: String

  # Validations
  validates :name, presence: true, uniqueness: true

  # callbacks
  after_destroy :update_todos_tag_ids

  def get_todo_items
    TodoItem.in(tag_ids: self.id)
  end

  private
  def update_todos_tag_ids
    TodoItem.all.pull(tag_ids: self.id)
  end
end
