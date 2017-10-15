class RecentMediaDecorator
  def initialize(json_response)
    @json_response = json_response
  end

  def images
    @json_response['data'].map { |info| info['images']['low_resolution']['url'] }
  end
end
