class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.belongs_to :todo_list, index: true, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
