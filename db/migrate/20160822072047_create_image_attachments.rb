class CreateImageAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :image_attachments do |t|
      t.string :file
      t.references :imageable, polymorphic: true, index: true 
      t.timestamps
    end
  end
end
