class AddAccessTokenToTwitterAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :twitter_accounts, :access_token, :string
  end
end
