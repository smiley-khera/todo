attributes :id, :title, :description, :status, :created_at, :updated_at
node (:tags) {|todo_item| todo_item.tags.to_s}
node (:url)  {|todo_item| todo_item_url(todo_item, format: :json)}