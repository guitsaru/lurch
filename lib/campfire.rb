module CampFire
  class HTTP
    def self.campfire
      Tinder::Campfire.new Setting.by_key('campfire_account'), :token => Setting.by_key('campfire_token')
    end

    def self.room
      @room ||= Campfire.campfire.rooms.select {|r| r.name == Setting.by_key('campfire_room')}.first
    end

    def self.speak(text)
      room.speak(text)
    end
  end

  class Test
    def self.campfire
    end

    def self.room
    end

    def self.speak(text)
    end
  end
end

Campfire = if !defined?(Rails) || Rails.env.test?
             CampFire::Test
           else
             CampFire::HTTP
           end
