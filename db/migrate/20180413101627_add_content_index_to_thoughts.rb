class AddContentIndexToThoughts < ActiveRecord::Migration[5.1]
  def change
    Thought.connection.execute("CREATE INDEX ON thoughts USING gin(to_tsvector('english', content));")
  end
end
