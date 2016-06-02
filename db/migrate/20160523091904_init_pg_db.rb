class InitPgDb < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string   :email,              null:    false, default:   ""
      t.string   :encrypted_password, null:    false, default:   ""
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer  :sign_in_count,      default: 0,     null:      false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
      t.string   :name,               null:    false, default:   ""
      t.integer  :points,             null:    false, default:   0
      t.boolean  :admin,              null:    false, default:   false
      t.string   :phone,              null:    false, default:   ""
      t.string   :oauth_login_code,   null:    false, default:   ""
      t.boolean  :online,             null:    false, default:   false
      t.string   :avatar
      t.decimal  :longitude,          null:    false, precision: 9, scale: 6, default: 0
      t.decimal  :latitude,           null:    false, precision: 9, scale: 6, default: 0
      t.string   :mongo_id
    end
    
    add_index :users, :email, unique: true, using: :btree
    add_index :users, :name,  unique: true, using: :btree
    add_index :users, :phone, unique: true, using: :btree

    create_table :travel_plans do |t|
      t.string     :content,              default:   ""
      t.datetime   :start_off_time
      t.decimal    :dest_loc_longitude, precision: 9, scale: 6, null: false
      t.decimal    :dest_loc_latitude, precision: 9, scale: 6, null: false
      t.integer    :status,               default:   0
      t.belongs_to :user
      t.timestamps
    end

    create_table :passing_locations do |t|
      t.decimal :longitude, null: false, precision: 9, scale: 6
      t.decimal :latitude, null: false, precision: 9, scale: 6
      t.belongs_to :travel_plan
    end

    create_table :friendships do |t|
      t.datetime :requested_at
      t.datetime :accepted_at
      t.string   :status
      t.integer  :friend_id
      t.belongs_to :user
    end
    add_index :friendships, :friend_id, using: :btree
    add_index :friendships, :status, using: :btree


    create_table :actions do |t|
      t.integer  :category,  default: 0
      t.string   :title
      t.string   :place
      t.datetime :start_at
      t.datetime :end_at
      t.text     :content,   default:   ""
      t.decimal  :price,     precision: 10, scale: 2, default: 0
      t.decimal  :longitude, precision: 9, scale: 6, default: 0
      t.decimal  :latitude,  precision: 9, scale: 6, default: 0
      t.integer  :distance, default: 0
      t.timestamps
      t.belongs_to :user
    end

    create_table :action_image_attachments do |t|
      t.string     :file
      t.belongs_to :action
    end

    create_table :action_video_attachments do |t|
      t.string     :file
      t.belongs_to :action
    end

    create_table :senders do |t|
      t.string   :name,    default: ""
      t.string   :phone,   default: ""
      t.string   :address, default: ""
      t.belongs_to :action
    end

    create_table :receivers do |t|
      t.string   :name,    default: ""
      t.string   :phone,   default: ""
      t.string   :address, default: ""
      t.belongs_to :action
    end

    create_table :app_versions do |t|
      t.string :version,   null: false
      t.string :changelog, default: ''
      t.string :name
      t.string :app,       null: false
      t.timestamps
    end

    create_table :articles do |t|
      t.string  :title
      t.string  :title_image_url
      t.string  :body
      t.boolean :published, default: false
      t.timestamps
    end

    enable_extension 'hstore'
    create_table :bikes do |t|
      t.string  :name,           default:   ""
      t.string  :module_id,      null: false
      t.decimal :longitude,      precision: 9, scale: 6, default: 0.0
      t.decimal :latitude,       precision: 9, scale: 6, default: 0.0
      t.decimal :battery,        precision: 6, scale: 2, default: 0.0
      t.decimal :travel_mileage, precision: 10,scale: 2, default: 0.0
      t.hstore  :diag_info, default: {}
      t.belongs_to :user
    end
    add_index :bikes, :module_id, unique: true, using: :btree
    add_index :bikes, :diag_info, using: :gin

    create_table :locations do |t|
      t.decimal    :longitude, precision: 9, scale: 6, default: 0.0
      t.decimal    :latitude,  precision: 9, scale: 6, default: 0.0
      t.belongs_to :bike
      t.timestamps
    end

    create_table :media do |t|
      t.integer    :type
      t.string     :media
      t.belongs_to :user
      t.timestamps
    end

    create_table :topics do |t|
      t.string     :subject
      t.text       :text
      t.integer    :views_count, default: 1
      t.belongs_to :user
      t.timestamps
    end

    create_table :posts do |t|
      t.text       :text
      t.belongs_to :user
      t.belongs_to :topic
      t.timestamps
    end
    

    create_table :sms_validation_codes do |t|
      t.string  :validation_code
      t.string  :phone
      t.integer :expires_in
      t.integer :type
      t.timestamps
    end


    create_table :oauth_applications do |t|
      t.string  :name,         null: false
      t.string  :uid,          null: false
      t.string  :secret,       null: false
      t.text    :redirect_uri, null: false
      t.string  :scopes,       null: false, default: ''
      t.timestamps
      t.integer :owner_id
      t.string  :owner_type
      t.string  :mongo_id
    end

    add_index :oauth_applications, :uid, unique: true, using: :btree
    add_index :oauth_applications, ["owner_id", "owner_type"], using: :btree

    create_table :oauth_access_grants do |t|
      t.integer  :resource_owner_id, null: false
      t.references :application,     null: false
      t.string   :token,             null: false
      t.integer  :expires_in,        null: false
      t.text     :redirect_uri,      null: false
      t.datetime :created_at,        null: false
      t.datetime :revoked_at
      t.string   :scopes
    end

    add_index :oauth_access_grants, :token, unique: true, using: :btree
    add_foreign_key(
      :oauth_access_grants,
      :oauth_applications,
      column: :application_id
    )

    create_table :oauth_access_tokens do |t|
      t.integer    :resource_owner_id
      t.references :application,            null: false
      t.string     :token,                  null: false
      t.string     :refresh_token
      t.integer    :expires_in
      t.datetime   :revoked_at
      t.datetime   :created_at,             null: false
      t.string     :scopes
    end

    add_index :oauth_access_tokens, :token, unique: true, using: :btree
    add_index :oauth_access_tokens, :resource_owner_id, using: :btree
    add_index :oauth_access_tokens, :refresh_token, unique: true, using: :btree
    add_foreign_key(
      :oauth_access_tokens,
      :oauth_applications,
      column: :application_id
    )
  end
end
