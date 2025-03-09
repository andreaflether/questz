class AddNoticeableToNotices < ActiveRecord::Migration[6.1]
  def change
    remove_column :notices, :noticeable_type, :integer
    add_reference :notices, :noticeable, polymorphic: true
  end
end
