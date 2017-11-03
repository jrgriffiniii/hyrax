class AddCollectionTypeSharingOptions < ActiveRecord::Migration[5.0]
  def change
    add_column :hyrax_collection_types, :share_applies_to_collection, :boolean, null: false, default: true
    add_column :hyrax_collection_types, :share_applies_to_new_works, :boolean, null: false, default: true
  end
end
