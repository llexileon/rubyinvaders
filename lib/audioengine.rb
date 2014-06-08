module AudioEngine

  def audio_engine
    soundtrack
    foleyfx
  end

  def soundtrack # Game Soundtrack
    @soundtrack = [] 
    @soundtrack << Gosu::Song.new("assets/audio/invaders.mp3")
    @song = @soundtrack.first
    @song.play(looping = true)
  end

  def foleyfx # Game Foley
    @laser_sample = Gosu::Sample.new(self, "assets/audio/lasercanon.mp3") #wav for squib edition
    @boom_sample = Gosu::Sample.new(self, "assets/audio/explosion.wav")
    @impact_sample = Gosu::Sample.new(self, "assets/audio/shieldimpact.wav")
    @clash_sample = Gosu::Sample.new(self, "assets/audio/laserclash.wav")
  end

end
