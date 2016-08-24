class CreateVideoAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :video_attachments do |t|
      t.string :file
      t.timestamps
    end
  end
end
