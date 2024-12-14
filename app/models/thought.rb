class Thought < ApplicationRecord

  @ignore_words = ['the', 'this', 'a', 'at', 'is', 'by', 'for', 'as', 'from', 'it', 'and', 'in', 'be', 'I', 'of', 'very', 'when', 'which', 'or', 'why', 'up', 'will', 'now', 'more', 'because', 'like', 'you', 'me', 'between', 'under', 'over', 'use', 'getting', 'certain', 'may', 'maybe', 'can', 'can\'t', 'however', 'probably', 'won\'t', 'way', 'should', 'could', 'would'];

  def self.search_content(opts) 
    if !opts[:q].blank?
      where('similarity(content, ?) > 0.2', opts[:q])
      .order(Arel.sql("similarity(content, '#{opts[:q]}') DESC"))
    elsif !opts[:feel_lucky].blank?
      search_term = random.content
      @ignore_words.each do |word|
        search_term = search_term.gsub(/\b#{Regexp.escape(word)}\b/, '')
      end
      search_term = search_term.gsub(/[[:punct:]]/, '')
      search_content(q: search_term)
    else
      order(created_at: :desc).limit(25)
    end
  end

  def self.random
    order('RANDOM()').first
  end

end
