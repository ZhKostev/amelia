require_relative '../../../lib/external_apis/instagram/client'

# :reek:InstanceVariableAssumption
module Front
  class TagsController < ApplicationController
    before_action :increment_search_count, only: :show
    before_action :check_daily_limit, only: :show

    def index
      @tag = Tag.new
    end

    def show
      @tag = Tag.find(params[:id])
      @recent_media_info = RecentMediaDecorator.new(instagram_client.tag_recent_media(@tag.name))
      @recent_media_info.images.each { |img_url| enqueue_worker(params[:tag_search_id], img_url) }
    end

    def create
      @tag = Tag.find_or_initialize_by(name: tag_params[:name])
      if @tag.save
        redirect_to tag_path(@tag,
                             tag_search_id: @tag.tag_searches.create!(visitor_id: instagram_session.visitor_id).id)
      else
        render :index
      end
    end

    private

    def enqueue_worker(tag_search_id, img_url)
      ImageProcessWorkerJob.set(wait: (0.15 + rand(300) / 100.to_f).seconds).perform_later(tag_search_id, img_url)
    end

    def tag_params
      params.require(:tag).permit(:name)
    end

    def instagram_client
      ::Instagram::Client.new(instagram_session.token)
    end

    def check_daily_limit
      redirect_to tags_path, alert: SearchLimitChecker::ALERT_MSG if SearchLimitChecker.limit_is_reached?
    end

    # :reek:UtilityFunction
    def increment_search_count
      SearchLimitChecker.search_is_performed
    end
  end
end
