json.extract! todo_item, :id, :title, :description, :status, :created_at, :updated_at
json.tags todo_item.tags.to_s
json.url todo_item_url(todo_item, format: :json)
