module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :unique_id
 
    def connect
      self.unique_id = SecureRandom.urlsafe_base64
    end
  end
end
