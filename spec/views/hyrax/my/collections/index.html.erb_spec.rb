RSpec.describe "hyrax/my/collections/index.html.erb", type: :view do
  let(:resp) { double(docs: "", total_count: 11) }

  before do
    assign(:managed_collection_count, 0)
    assign(:response, resp)
    # allow(controller).to receive(:controller_name).and_return('my')
    # view.lookup_context.prefixes.push 'hyrax/my'

    allow(view).to receive(:can?).with(any_args).and_return(false)

    stub_template "hyrax/my/collections/_scripts" => " "
    stub_template "hyrax/my/collections/_default_group" => " "
    stub_template "hyrax/my/collections/_search_header" => " "
    stub_template "hyrax/my/collections/_results_pagination" => " "
    stub_template "hyrax/my/collections/_tabs" => " "
    stub_template "hyrax/my/collections/_modal_add_to_collection" => " "
    stub_template "hyrax/my/collections/_modal_add_to_collection_deny" => " "
    stub_template "hyrax/my/collections/_modal_add_to_collection_permission_deny" => " "
    stub_template "hyrax/my/collections/_modal_collection_types_to_create" => " "
    stub_template "hyrax/my/collections/_modal_delete_admin_set_deny" => " "
    stub_template "hyrax/my/collections/_modal_delete_collection" => " "
    stub_template "hyrax/my/collections/_modal_delete_collection_deny" => " "
    stub_template "hyrax/my/collections/_modal_delete_collections_deny" => " "
    stub_template "hyrax/my/collections/_modal_delete_deny" => " "
    stub_template "hyrax/my/collections/_modal_delete_empty_collection" => " "
    stub_template "hyrax/my/collections/_modal_delete_selected_collections" => " "
    stub_template "hyrax/my/collections/_modal_edit_deny" => " "
  end

  it 'indicate the number of collections to be 11' do
    render
    expect(rendered).to have_content("11 collections in the repository")
  end
  context 'when any user is logged in' do
    before do
      allow(view).to receive(:user).and_return(user)
    end

    let(:user) { create(:user) }
    it 'does show New Collection button', js: true do
      render
      expect(rendered).not_to have_link "New Collection"
      expect(rendered).not_to have_button "New Collection"
    end
    context 'when a user can create collections' do
      let(:user) { create(:admin) }
      let(:collection_type_list_presenter) do
        instance_double(Hyrax::SelectCollectionTypeListPresenter, any?: true, many?: true)
      end
      before do
        allow(view).to receive(:can?).with(:create_any, Collection).and_return(true)
        assign(:collection_type_list_presenter, collection_type_list_presenter)
      end

      it 'shows the New Collection button' do
        render
        expect(rendered).to have_button "New Collection"
      end
    end
  end
end
