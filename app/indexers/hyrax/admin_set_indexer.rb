module Hyrax
  class AdminSetIndexer < ActiveFedora::IndexingService
    include Hyrax::IndexesThumbnails

    self.thumbnail_path_service = Hyrax::CollectionThumbnailPathService

    def generate_solr_document
      super.tap do |solr_doc|
        # Makes Admin Sets show under the "Admin Sets" tab
        solr_doc['generic_type_sim'] = ['Admin Set']
      end
    end
  end
end
