class AddFacebookAndTwitterAndLinkedinAndInstagramToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook, :string
    add_column :users, :twitter, :string
    add_column :users, :linkedin, :string
    add_column :users, :instagram, :string
  end
end
