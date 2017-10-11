# :reek:InstanceVariableAssumption
class Front::TagsController < ApplicationController
  def index
    @tag = Tag.new
  end

  def show
    @tag = Tag.find(params[:id])
  end

  def create
    @tag = Tag.find_or_initialize_by(name: tag_params[:name])
    if @tag.save
      @tag.tag_searches.create!(visitor_id: instagram_session.visitor_id)
      redirect_to @tag
    else
      render :index
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
