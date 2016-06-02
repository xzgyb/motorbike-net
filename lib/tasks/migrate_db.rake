namespace :migrate do
  desc 'Migrate database from mongodb to postgresql'
  task :db => :environment do
    client = Mongo::Client.new(['127.0.0.1:27017'], database: 'motorbike_net_development')

    ActiveRecord::Base.transaction do
      insert_data(client, User, :users)
      
      insert_data(client, Doorkeeper::Application, :oauth_applications) do |oauth_application|
        get_id_mapping(User, oauth_application, :owner_id)
      end
     
      insert_data(client, Doorkeeper::AccessGrant, :oauth_access_grants) do |grant|
        get_id_mapping(User, grant, :resource_owner_id).merge(
          get_id_mapping(Doorkeeper::Application, grant, :application_id))
      end

      insert_data(client, Doorkeeper::AccessToken, :oauth_access_tokens) do |grant|
        get_id_mapping(User, grant, :resource_owner_id).merge(
          get_id_mapping(Doorkeeper::Application, grant, :application_id))
      end

    end 
  end
end

def insert_data(client, model_class, table_name)
  model_class.delete_all
  attributes = model_class.attribute_names
  model_class.bulk_insert do |pg_model|
    client[table_name].find.each do |record|
      attrs = record.slice(*attributes)
      attrs.merge!(mongo_id: record['_id'].to_s) if attributes.include?('mongo_id') 
      attrs.merge!(yield(record)) if block_given?
      pg_model.add(attrs)
    end 
  end
end

def get_id_mapping(model_class, record, field)
  {field => model_class.where(mongo_id: record[field].to_s).first.try(:id)}
end
