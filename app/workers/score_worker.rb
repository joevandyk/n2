class ScoreWorker
  @queue = :scores

  # Takes a Scorable Type, Scorable ID, and the User ID responsible
  def self.perform(site_id, scorable_type, scorable_id, user_id)
    Site.current_id = site_id
    scorable = scorable_type.constantize.find(scorable_id)
    user = User.active.find_by_id(user_id)
    if user
      score = scorable.add_score(user.id)
      user.add_score! score
    end
  end
end
