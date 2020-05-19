class AddViewToMicroposts < ActiveRecord::Migration[5.2]
  def change
    add_column :microposts, :view, :integer
  end
end
