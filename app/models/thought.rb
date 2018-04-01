class Thought < ApplicationRecord

  def self.recent
    all.order(created_at: :desc).limit(1)
  end

end
