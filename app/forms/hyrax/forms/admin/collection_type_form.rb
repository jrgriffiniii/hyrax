module Hyrax
  module Forms
    module Admin
      class CollectionTypeForm
        include ActiveModel::Model
        attr_accessor :collection_type
        validates :title, presence: true

        delegate :title, :description, :discoverable, :nestable, :sharable,
                 :share_applies_to_collection, :share_applies_to_new_works,
                 :require_membership, :allow_multiple_membership, :assigns_workflow,
                 :assigns_visibility, :id, :collection_type_participants, :persisted?,
                 :collections?, :admin_set?, :user_collection?, to: :collection_type

        def share_applies_to
          return :share_applies_to_collection_and_new_works if share_applies_to_collection && share_applies_to_new_works
          return :share_applies_to_collection if share_applies_to_collection
          :share_applies_to_new_works
        end
      end
    end
  end
end
