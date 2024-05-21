class AddCategoryToBlogs < ActiveRecord::Migration[7.1]
  def up
    add_reference :blogs, :category, null: false, foreign_key: true
  end

  def down
    remove_reference :blogs, :category, foreign_key: true
  end
end
