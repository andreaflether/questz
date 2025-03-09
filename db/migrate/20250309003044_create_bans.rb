class CreateBans < ActiveRecord::Migration[6.1]
  def change
    create_table :bans do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :ban_author, foreign_key: { to_table: :users }, index: true, null: true
      t.integer :ban_type, comment: '0: Temporary, 1: Permanent', default: 0, null: false
      t.integer :status, comment: '0: Active, 1: Ended, 2: Revoked', default: 0, index: true, null: false
      t.datetime :ends_at
      t.text :reason, null: false
      t.integer :total_notices
      t.boolean :acknowledged_ban

      # Revoked columns (when an unban is applied)
      t.references :revoker, foreign_key: { to_table: :users }, index: true, null: true
      t.datetime :revoked_at, index: true
      t.text :unban_reason

      t.timestamps
    end
  end
end
