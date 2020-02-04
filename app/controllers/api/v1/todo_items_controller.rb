class Api::V1::TodoItemsController < BaseController
  respond_to :json

  before_filter :set_todo_item, except: [:index, :create, :restore]
  before_filter :deleted_todo_item, only: [:restore]

  # GET /todo_items.json
  def index
      @todo_items = TodoItem.all.order(title: :asc)
                                .page(params[:page])
                                .per(params[:limit] || DEFAULT_ITEMS )
  end

  # Post /todo_items.json
  def create
    @todo_item = TodoItem.new(todo_item_params)
    if @todo_item.save
      respond_with @todo_item, status: :created, location: @todo_item
    else
      respond_with @todo_item, status: :unprocessable_entity
    end
  end

  # Get /todo_items/1.json
  def show
  end

  # PATCH/PUT /todo_items/1.json
  def update
    if @todo_item.update(todo_item_params)
      render :show, status: :ok
    else
      respond_with @todo_item, status: :unprocessable_entity
    end
  end

  # PATCH /todo_items/1/add_tags.json
  def add_tags
    if @todo_item.tags <<
        (params[:todo_item][:tag_ids].map { |tag| Tag.find(tag) })
      render :show, status: :ok
    else
      respond_with @todo_item, status: :unprocessable_entity
    end
  end

  #PATCH todo_items/1/remove_tag.json
  def remove_tag
    @todo_item.tags.delete(Tag.find(params[:todo_item][:tag_id]))
    render :show, status: :ok
  end

  # DELETE /todo_items/1.json
  def destroy
    @todo_item.destroy #This method will soft delete the to-do item
    head :no_content
  end

  # PATCH /todo_items/1/restore.json
  def restore
    @todo_item.restore #This method will undo the deleted item
    render :show, status: :ok
  end

  private

  # Callback
  def set_todo_item
    @todo_item = TodoItem.find(params[:id])
  end

  def deleted_todo_item
    @todo_item = TodoItem.deleted.find(params[:id])
  end

  # Whitelist parameters
  def todo_item_params
    params.require(:todo_item).permit(:title, :description, :status)
  end
end
