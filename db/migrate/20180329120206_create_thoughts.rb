class CreateThoughts < ActiveRecord::Migration[5.1]
  def change
    create_table :thoughts do |t|
      t.text :content

      t.timestamps
    end
  end
end
