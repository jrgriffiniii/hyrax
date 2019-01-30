RSpec.describe Hyrax::ResourceSync::ChangeListWriter, :clean_repo do
  let(:sitemap) { 'http://www.sitemaps.org/schemas/sitemap/0.9' }
  let(:public_collection) { create(:public_collection) }
  let(:public_work) { create(:public_generic_work) }
  let(:file_set) do
    FileSet.create!(read_groups: ['public'])
  end
  let(:capability_list) { 'http://example.com/capabilityList.xml' }
  let(:xml) { Nokogiri::XML.parse(subject) }
  let(:url_list) { xml.xpath('//x:url', 'x' => sitemap) }
  let(:instance) do
    described_class.new(resource_host: 'example.com',
                        capability_list_url: capability_list)
  end
  let(:namespaces) do
    {
      'rs' => "http://www.openarchives.org/rs/terms/",
      'x' => sitemap
    }
  end
  let(:capability_element) { xml.xpath('//rs:ln/@href', 'rs' => "http://www.openarchives.org/rs/terms/") }

  subject { instance.write }

  context "without resources" do
    it "has a list of resources" do
      expect(url_list).to be_empty
    end
  end

  context "when resources exist" do
    before do
      # These private items should not show up.
      build(:private_collection_lw)
      create(:work)

      # Sleep in between to ensure modified dates are different
      public_collection
      sleep(1)
      public_work
      sleep(1)
      file_set
    end

    it "has a list of resources" do
      expect(capability_element.text).to eq capability_list
      expect(location(1)).to eq "http://example.com/concern/file_sets/#{file_set.id}"
      changed_elements = changed(1, namespaces)
      expect(location(2)).to eq "http://example.com/concern/generic_works/#{public_work.id}"
      changed_elements += changed(2, namespaces)
      expect(location(3)).to eq "http://example.com/collections/#{public_collection.id}"
      changed_elements += changed(3, namespaces)
      expect(changed_elements.map(&:value)).to eq ['created', 'created', 'created']

      expect(url_list.count).to eq 3
    end
  end

  def changed(n, namespaces = {})
    xml.xpath("//x:url[#{n}]/rs:md/@change", namespaces)
  end

  def location(n)
    query(n, 'x:loc')
  end

  def query(n, part, ns = {})
    xml.xpath("//x:url[#{n}]/#{part}", ns.merge('x' => sitemap)).text
  end
end
