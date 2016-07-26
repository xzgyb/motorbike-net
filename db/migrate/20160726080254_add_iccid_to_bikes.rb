class AddIccidToBikes < ActiveRecord::Migration[5.0]
  def change
    add_column :bikes, :iccid, :string
  end
end
