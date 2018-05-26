class Thought
  include Elasticsearch::Persistence::Model

  attribute :content,  String

  def self.search_content(opts) 
    if !opts[:q].blank?
      return search({
        query: { fuzzy: { content: opts[:q] } }, 
        sort: [{ created_at: { order: 'desc'} }]
      })
    elsif !opts[:more_like_this].blank?
      thought = find(opts[:more_like_this])
      return thought.more_like_this
    elsif !opts[:feel_lucky].blank?
      return Thought.feel_lucky
    else
      return all({
        sort: [{ created_at: { order: 'desc'} }]
      })
    end
  end

  def self.feel_lucky
    self.random.more_like_this
  end

  def self.random
    return search({
      size: 1,
      query: {
        function_score: {
          functions: [
            { random_score: { seed: Time.now } }
          ]
        }
      }
    }).first
  end

  def more_like_this
    return Thought.search({
      query: { more_like_this: { 
        fields: [ 'content' ],
        like: content,
        min_term_freq: 1,
        min_word_length: 5,
        include: true,
        max_query_terms: 25,
        min_doc_freq: 1 
      } }, 
      sort: [{ created_at: { order: 'desc'} }]
    });
  end

end
