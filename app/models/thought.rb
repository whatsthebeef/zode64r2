class Thought < ApplicationRecord

  def self.recent
    all.order(created_at: :desc).limit(1)
  end

  def self.search(text)
    if text.blank?
      all.order(created_at: :desc)
    else 
      basic_search(content: text)
    end
  end

end
