class DropActionVideoAttachments < ActiveRecord::Migration[5.0]
  def up
    drop_table :action_video_attachments
  end

  def down
    create_table :action_video_attachments do |t|
      t.string     :file
      t.belongs_to :action
    end
  end
end
