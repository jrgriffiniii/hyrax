RSpec.describe 'hyrax/dashboard/works/_list_works.html.erb', type: :view do
  include Devise::Test::ControllerHelpers

  let(:document_values) do
    {
      "system_create_dtsi" => "2019-01-29T15:33:48Z",
      "system_modified_dtsi" => "2019-01-29T15:33:49Z",
      "has_model_ssim" => ["GenericWork"],
      "id" => "332ec6b3-5241-4d8a-b43e-9ca02fd5c14d",
      "accessControl_ssim" => ["4a90cf7c-ab25-4fa6-a715-6555d4cf6ca8"],
      "depositor_ssim" => ["user3@example.com"],
      "depositor_tesim" => ["user3@example.com"],
      "title_tesim" => ["Testing #1"],
      "isPartOf_ssim" => ["fc337139-8964-485e-a3ba-dfefaad75292"],
      "thumbnail_path_ss" => "/assets/work-ff055336041c3f7d310ad69109eda4a887b16ec501f35afc0a547c4adb97ee72.png",
      "suppressed_bsi" => false,
      "member_of_collections_ssim" => ["Collection Title 1"],
      "member_of_collection_ids_ssim" => ["object_id_1"],
      "visibility_ssi" => "restricted",
      "admin_set_tesim" => ["Title 1"],
      "human_readable_type_tesim" => ["Generic Work"],
      "edit_access_person_ssim" => ["user3@example.com"],
      "_version_" => 1_624_009_373_481_172_992,
      "timestamp" => "2019-01-29T15:33:49.092Z",
      "score" => 1.0
    }
  end
  let(:document) { ::SolrDocument.new(document_values) }
  let(:workflow) { instance_double(Hyrax::WorkflowPresenter, state_label: 'complete') }
  let(:presenter) { instance_double(Hyrax::WorkShowPresenter, workflow: workflow) }

  before do
    # This is necessary for the permissions Solr query
    stub_request(:get, "http://127.0.0.1:8985/solr/hydra-test/select?fq=(%7B!terms%20f=edit_access_group_ssim%7Dpublic)%20OR%20(%7B!terms%20f=read_access_group_ssim%7Dpublic)&rows=100&wt=json").and_return(body: JSON.generate(response: { docs: [document_values] }))
    stub_request(:get, "http://127.0.0.1:8985/solr/hydra-test/select?q=(_query_:%22%7B!raw%20f=has_model_ssim%7DGenericWork%22%20OR%20_query_:%22%7B!raw%20f=has_model_ssim%7DNamespacedWorks::NestedWork%22)%20AND%20_query_:%22%7B!field%20f=id%7D#{CGI.escape(document.id)}%22%20AND%20-depositor_ssim:%5B*%20TO%20*%5D&qt=standard&sort=system_create_dtsi%20asc&wt=json").to_return(body: JSON.generate(response: { docs: [] }))
    stub_request(:get, "http://127.0.0.1:8985/solr/hydra-test/select?id=#{document.id}&qt=permissions&wt=json").to_return(body: JSON.generate(response: { docs: [document_values] }))
    allow(controller).to receive(:controller_name).and_return('my')
    view.lookup_context.prefixes.push 'hyrax/my'

    allow(view).to receive(:display_trophy_link)
    allow(view).to receive(:document).and_return(document)
    allow(view).to receive(:presenter).and_return(presenter)
    render
  end
  context 'when a work have been ingested' do
    it 'renders the title and state' do
      expect(rendered).to have_content 'Testing #1'
      expect(rendered).to have_content 'complete'
    end
  end
end
