class AddLivingToVideoAttachment < ActiveRecord::Migration[5.0]
  def change
    add_reference :video_attachments, :living, foreign_key: true
  end
end
