class YouTrack::Client::Users < YouTrack::Client::Collection
  model YouTrack::Client::User

  def current
    service.users.new(service.get_current_user.body)
  end

  def get(username)
    service.users.new(service.get_user(username).body)
  rescue Faraday::ClientError => e
    # yes 403 if you have valid creds BUT the user isn't there
    raise unless [403, 404].include?(e.response[:status])
    nil
  end
end
