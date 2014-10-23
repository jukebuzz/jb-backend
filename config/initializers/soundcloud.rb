class Soundcloud
  cattr_accessor :current
end
Soundcloud.current = Soundcloud.new(client_id: Rails.application.secrets.soundcloud_client_id)
