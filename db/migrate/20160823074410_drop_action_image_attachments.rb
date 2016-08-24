class DropActionImageAttachments < ActiveRecord::Migration[5.0]
  def up
    drop_table :action_image_attachments
  end

  def down  
    create_table :action_image_attachments do |t|
      t.string     :file
      t.belongs_to :action
    end
  end

end
