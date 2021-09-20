class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :content, null: true, default: nil
      t.string :post_image, null: true, default: nil

      t.timestamps
    end
  end
end
