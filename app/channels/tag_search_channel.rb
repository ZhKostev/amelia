class TagSearchChannel < ApplicationCable::Channel
  def subscribed
    stream_from self.class.stream_name(params[:tag_search_id])
  end

  def self.stream_name(tag_search_id)
    "tag_search_#{tag_search_id}"
  end
end
