<% pundit = defined? Pundit -%>
<% fbot = defined? FactoryBot -%>
<% if File.exist?(File.join %w[spec rails_helper.rb]) -%>
require 'rails_helper'
<% else -%>
require 'spec_helper'
<% end -%>

<% module_namespacing do -%>
describe "Request /<%= name.underscore.pluralize %>", <%= type_metatag(:request) %> do
<% if fbot -%>
  let(:<%= file_name %>) { create :<%= file_name %> }
<%   if pundit -%>
  let(:user) { create :user }
<%   end -%>
<% else -%>
  let(:<%= file_name %>) { <%= class_name %>.create! valid_attributes }
<% end -%>

  # This should return the minimal set of attributes required to create a valid
  # <%= class_name %>. As you add validations to <%= class_name %>, be sure to
  # adjust the attributes here as well.
<% attributes.map{|a| [a.name, a.type]} -%>
<% if fbot -%>
<% links = attributes.select{|a| [:belongs_to, :references].include? a.type} -%>
<% attribute = (attributes - links).detect{|a| a.name == 'name' || a.name == 'title' || a.name == 'code' || a.name =~ /name/ || a.name =~ /title/} || attributes.detect{|a|  %i[string text].include? a.type} || attributes.last -%>
<% attribute_name = attribute.respond_to?(:column_name) ? attribute.column_name : attribute.name -%>
<% if links.present? -%>
  let(:valid_attributes) do
    attributes_for(:<%=file_name%>)
      .slice(*%i[<%= attribute_name %>])
      .merge(
<% links.each do |relation| -%>
        <%= relation.name %>_id: create(:<%= relation.name %>).id,
<% end -%>
      )
  end
<% else -%>
  let(:valid_attributes) {attributes_for(:<%=file_name%>).slice *%i[<%= attribute_name %>]}
<% end -%>
<% else -%>
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }
<% end -%>

  let(:invalid_attributes) do
    skip("Add a hash of attributes invalid for your model")
    { <%= attribute_name %>: '' }
  end

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # <%= controller_class_name %>Controller, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) {
    {}
  }

<% unless options[:singleton] -%>
  describe 'GET /index' do
    it "renders a successful response" do
      <%= class_name %>.create! valid_attributes
      get <%= index_helper %>_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end
<% end -%>

  describe 'GET /show' do
    subject(:get_show) { get <%= show_helper %> }

    it "renders a successful response" do
      get_show
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    subject(:post_create) do
      post <%= index_helper %>_url,
            params: { data: data },
            headers: valid_headers,
            as: :json
    end
    let(:data) do
      {
        type: '<%= table_name %>',
        attributes: attributes,
      }
    end
    let(:attributes) { valid_attributes }

    context 'with valid parameters' do
      it "creates a new <%= class_name %>" do
        expect { post_create }.to change(<%= class_name %>, :count).by(1)
      end

      it 'returns :created' do
        post_create
        expect(response).to have_http_status(:created)
      end

      it 'renders content_type "application/vnd.api+json; charset=utf-8"' do
        post_create
        expect(response.content_type).to eq("application/vnd.api+json; charset=utf-8")
      end

      it "renders a JSON response with the new <%= file_name %>" do
        post_create
        expect(JSON.parse(response.body)['data']['id'])
            .to eq <%= class_name %>.order(:created_at).last.id
      end
    end

    context 'with invalid parameters' do
      let(:attributes) { invalid_attributes }

      it "does not create a new <%= class_name %>" do
        expect { post_create }.not_to change <%= class_name %>, :count
      end

      it 'returns :unprocessable_entity' do
        post_create
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders content_type "application/vnd.api+json; charset=utf-8"' do
        post_create
        expect(response.content_type).to eq("application/vnd.api+json; charset=utf-8")
      end

      it 'renders a JSON response with errors for the new <%= file_name %>' do
        post_create
        expect(JSON.parse(response.body).dig 'errors', 0, 'meta', 'attribute')
            .to be_present
      end
    end
  end

  describe 'PATCH /update' do
    subject(:patch_update) do
      patch <%= file_name %>_url(<%= file_name %>),
            params: { data: data },
            headers: valid_headers,
            as: :json
    end
    let(:data) do
      {
        id: <%= file_name %>.id.to_s,
        type: '<%= file_name %>s',
        attributes: new_attributes,
      }
    end
    let(:new_attributes) {
      skip("Add a hash of attributes valid for <%= class_name %>")
      {  <%= attribute_name %>: 'New <%= attribute_name %>' }
    }

    context "with valid parameters" do
      it "updates the requested <%= file_name %>" do
        patch_update
        <%= file_name %>.reload
        skip("Add assertions for updated state")
        <%= file_name %>.<%= attribute_name %> == 'New <%= attribute_name %>'
      end

      it 'returns :ok' do
        patch_update
        expect(response).to have_http_status :ok
      end

      it 'renders content_type "application/vnd.api+json; charset=utf-8"' do
        patch_update
        expect(response.content_type).to eq("application/vnd.api+json; charset=utf-8")
      end

      it "renders a JSON response with the <%= file_name %>" do
        patch_update
        expect(JSON.parse(response.body)['data']['id']).to eq <%= file_name %>.id
      end
    end

    context "with invalid parameters" do
      let(:new_attributes) { invalid_attributes }

      it "does not update the requested <%= file_name %>" do
        expect { patch_update }.not_to change <%= file_name %>, :reload
      end

      it 'returns :unprocessable_entity' do
        patch_update
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders content_type "application/vnd.api+json; charset=utf-8"' do
        patch_update
        expect(response.content_type).to eq("application/vnd.api+json; charset=utf-8")
      end

      it "renders a JSON response with errors for the new <%= file_name %>" do
        patch_update
        expect(JSON.parse(response.body).dig 'errors', 0, 'meta', 'attribute')
            .to be_present
      end
    end
  end

  describe "DELETE /destroy" do
    subject(:delete_destroy) do
      delete <%= file_name %>_url(id: <%= file_name %>.to_param)
    end

    before do
      <%= file_name %>  # we need something to destroy
    end

    it "destroys the requested <%= file_name %>" do
      expect { delete_destroy }.to change(<%= class_name %>, :count).by -1
    end

    it 'returns :no_content' do
      delete_destroy
      expect(response).to have_http_status(:no_content)
    end

    it "renders empty response" do
      delete_destroy
      expect(response.body).to be_empty
    end
  end
end
<% end -%>
