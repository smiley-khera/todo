class Api::V1::TagsController < BaseController
  respond_to :json
  before_filter :set_tag, except: [:index, :create]

  # GET /tags.json
  def index
    @tags = Tag.all.order(name: :asc)
                   .page(params[:page])
                   .per(params[:limit] || DEFAULT_ITEMS)
  end

  # Post /tags.json
  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      render :show, status: :created, location: @tag
    else
      respond_with @tag, status: :unprocessable_entity
    end
  end

  # Get /tags/1.json
  def show
  end

  # PATCH/PUT /tags/1.json
  def update
    if @tag.update(tag_params)
      render :show, status: :ok
    else
      respond_with @tag, status: :unprocessable_entity
    end
  end

  # DELETE /tags/1.json
  def destroy
    @tag.destroy
    head :no_content
  end

  # Get tag specific to-do items
  def todo_items
    @todo_items = @tag.get_todo_items.order(title: :asc).page(params[:page])
    render template: "api/v1/todo_items/index"
  end

  private
  # Callback
  def set_tag
    @tag = Tag.find(params[:id])
  end

  # Whitelist parameters
  def tag_params
    params.require(:tag).permit(:name)
  end

end