RSpec.describe "hyrax/dashboard/show_admin.html.erb", type: :view do
  let(:transfer_presenter) do
    instance_double(Hyrax::TransfersPresenter,
                    render_sent_transfers: 'sent transfers',
                    render_received_transfers: 'received transfers')
  end
  let(:activity) { [] }
  let(:repository_growth) do
    instance_double(Hyrax::Admin::RepositoryGrowthPresenter, to_json: "[]")
  end
  let(:repository_objects) do
    instance_double(Hyrax::Admin::RepositoryObjectPresenter, to_json: "[]")
  end
  let(:presenter) do
    instance_double(Hyrax::Admin::DashboardPresenter,
                    user_activity: activity,
                    repository_growth: repository_growth,
                    repository_objects: repository_objects)
  end
  let(:user) { create(:admin) }
  let(:admin_set_service) { instance_double(Hyrax::AdminSetService) }
  let(:admin_set_rows) { admin_set_service.search_results_with_work_count(:read) }
  let(:admin_set_document) do
    ::SolrDocument.new(
      "system_create_dtsi" => "2019-01-28T21:43:56Z",
      "system_modified_dtsi" => "2019-01-28T21:43:56Z",
      "has_model_ssim" => ["AdminSet"],
      "id" => "admin_set/default",
      "accessControl_ssim" => ["144a2b72-9c59-4cfc-b0fb-bd599318a893"],
      "title_tesim" => ["Default Admin Set"],
      "thumbnail_path_ss" => "/assets/collection-a38b932554788aa578debf2319e8c4ba8a7db06b3ba57ecda1391a548a4b6e0a.png",
      "edit_access_group_ssim" => ["admin"],
      "human_readable_type_tesim" => ["Admin Set"],
      "_version_" => 1_623_942_062_370_979_840,
      "timestamp" => "2019-01-28T21:43:56.215Z",
      "score" => 1.0
    )
  end
  let(:search_result_for_work_count) do
    SearchResultForWorkCount = Struct.new(:admin_set, :work_count, :file_count)
    [
      SearchResultForWorkCount.new(admin_set_document, 1, 0)
    ]
  end
  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(presenter).to receive(:user_count).and_return(1)
    allow(admin_set_service).to receive(:search_results_with_work_count).and_return(search_result_for_work_count)
    assign(:presenter, presenter)
    assign(:admin_set_rows, admin_set_service.search_results_with_work_count(:read))
    render
  end

  context "upon sign-in" do
    it "shows the admin user's information" do
      expect(rendered).to have_content "Registered Users"
      expect(rendered).to have_content "Total Visitors"
      expect(rendered).to have_content "Returning Visitors"
      expect(rendered).to have_content "New Visitors"
      expect(rendered).to have_content "Administrative Sets"
      expect(rendered).to have_content "Recent activity"
      expect(rendered).to have_content "Administrative Set"
      expect(rendered).to have_content "User Activity"
      expect(rendered).to have_content "Repository Growth"
      expect(rendered).to have_content "Repository Objects"

      within '.sidebar' do
        expect(rendered).to have_link "Works"
        expect(rendered).to have_link "Collections"
        expect(rendered).to have_content "Review Submissions"
        expect(rendered).to have_content "Manage Embargoes"
        expect(rendered).to have_content "Manage Leases"
      end
    end
  end
end
