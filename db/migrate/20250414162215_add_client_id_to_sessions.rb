class AddClientIdToSessions < ActiveRecord::Migration[8.0]
  def change
    add_column :sessions, :client_id, :string
    add_index :sessions, :client_id
  end
end
