class AddSearchToBookmarks < ActiveRecord::Migration[7.1]
  def change
    add_column :bookmarks, :search, :string
  end
end
