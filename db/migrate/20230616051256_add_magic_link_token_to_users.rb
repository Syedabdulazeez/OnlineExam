class AddMagicLinkTokenToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :magic_link_token, :string
  end
end
