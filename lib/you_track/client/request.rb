class YouTrack::Client::Request
  def find(collection, id, options={})
    service.data.fetch(collection)[id] ||
      service.response(
        :status => options[:error_status] || 404,
        :body   => { "error" => options[:error_message] || "#{collection.to_s.gsub(/s\Z/, "").capitalize} not found." }
    )
  end

  def require_parameters(_params, *_requirements)
    params       = Cistern::Hash.stringify_keys(_params)
    requirements = _requirements.map(&:to_s)

    requirements.each do |requirement|
      unless !params[requirement].nil?
        response(
          :status => 400,
          :body   => {"error" => "Bad Request"})
      end
    end
    values = params.values_at(*requirements)
    values.size == 1 ? values.first : values
  end

  def ms_time(time=Time.now)
    time.to_i * 1000
  end
end
