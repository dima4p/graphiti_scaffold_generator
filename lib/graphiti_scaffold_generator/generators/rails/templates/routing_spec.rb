<% prefix = "/api/#{options[:api_version]}" if options[:api] -%>
require "rails_helper"

<% module_namespacing do -%>
describe <%= controller_class_name %>Controller, <%= type_metatag(:routing) %> do
  describe "routing" do
<% unless options[:singleton] -%>
    it "routes to #index" do
      expect(get: "<%= prefix %>/<%= ns_table_name %>")
          .to route_to "<%= ns_table_name %>#index", "format"=>:jsonapi
    end

<% end -%>
<% unless options[:api] -%>
    it "routes to #new" do
      expect(get: "/<%= ns_table_name %>/new").to route_to("<%= ns_table_name %>#new")
    end

<% end -%>
    it "routes to #show" do
      expect(get: "<%= prefix %>/<%= ns_table_name %>/1")
          .to route_to "<%= ns_table_name %>#show", id: "1", "format"=>:jsonapi
    end

<% unless options[:api] -%>
    it "routes to #edit" do
      expect(get: "/<%= ns_table_name %>/1/edit").to route_to("<%= ns_table_name %>#edit", id: "1")
    end

<% end -%>

    it "routes to #create" do
      expect(post: "<%= prefix %>/<%= ns_table_name %>")
          .to route_to "<%= ns_table_name %>#create", "format"=>:jsonapi
    end

    it "routes to #update via PUT" do
      expect(put: "<%= prefix %>/<%= ns_table_name %>/1")
          .to route_to "<%= ns_table_name %>#update", id: "1", "format"=>:jsonapi
    end

    it "routes to #update via PATCH" do
      expect(patch: "<%= prefix %>/<%= ns_table_name %>/1")
          .to route_to "<%= ns_table_name %>#update", id: "1", "format"=>:jsonapi
    end

    it "routes to #destroy" do
      expect(delete: "<%= prefix %>/<%= ns_table_name %>/1")
          .to route_to "<%= ns_table_name %>#destroy", id: "1", "format"=>:jsonapi
    end
  end
end
<% end -%>
