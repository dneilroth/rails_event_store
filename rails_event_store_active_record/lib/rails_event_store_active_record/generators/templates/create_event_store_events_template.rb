class CreateEventStoreEvents < ActiveRecord::Migration<%= migration_version %>
  def change
    postgres = ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
    enable_extension "pgcrypto" if postgres
    create_table(:event_store_events_in_streams, force: false) do |t|
      t.string      :stream,      null: false
      t.integer     :position,    null: true
      if postgres
        t.references :event, null: false, type: :uuid
      else
        t.references :event, null: false, type: :string, limit: 36
      end
      t.datetime    :created_at,  null: false
    end
    add_index :event_store_events_in_streams, [:stream, :position], unique: true
    add_index :event_store_events_in_streams, [:created_at]
    add_index :event_store_events_in_streams, [:stream, :event_id], unique: true

    create_table(:event_store_events, force: false) do |t|
      if postgres
        t.references :event, null: false, type: :uuid
      else
        t.references :event, null: false, type: :string, limit: 36
      end
      t.string      :event_type,  null: false
      t.binary      :metadata
      t.binary      :data,        null: false
      t.datetime    :created_at,  null: false
    end
    add_index :event_store_events, :event_id, unique: true
    add_index :event_store_events, :created_at
    add_index :event_store_events, :event_type
  end
end
