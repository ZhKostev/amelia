# :reek:InstanceVariableAssumption
class Front::TagsController < ApplicationController
  def index
    @tag = Tag.new
  end

  def show
    @tag = Tag.find(params[:id])
    @recent_media_info = RecentMediaDecorator.new(instagram_client.tag_recent_media(@tag.name))
    @recent_media_info.images.each { |img_url| ImageProcessWorkerJob.perform_later(params[:tag_search_id], img_url) }
  end

  def create
    @tag = Tag.find_or_initialize_by(name: tag_params[:name])
    if @tag.save
      redirect_to tag_path(@tag, tag_search_id: @tag.tag_searches.create!(visitor_id: instagram_session.visitor_id).id)
    else
      render :index
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

  def instagram_client
    Instagram::Client.new(instagram_session.token)
  end
end
