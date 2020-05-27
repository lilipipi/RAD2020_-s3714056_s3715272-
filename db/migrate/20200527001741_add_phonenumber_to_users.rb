class AddPhonenumberToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :phonenumber, :string
  end
end
