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
    else
      return all({
        sort: [{ created_at: { order: 'desc'} }]
      })
    end
  end

  def self.last
    find_in_batches(size: 1).peek.to_a.first
  end

  def more_like_this
    return Thought.search({
      query: { more_like_this: { 
        fields: [ 'content' ],
        like: content,
        min_term_freq: 1,
        max_query_terms: 1,
        min_doc_freq: 1
      } }, 
      sort: [{ created_at: { order: 'desc'} }]
    });
  end

end
