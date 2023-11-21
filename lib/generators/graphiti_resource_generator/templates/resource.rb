<% primary_key_type = Rails.application.config.generators.options[:active_record][:primary_key_type] -%>
<% belongs_to = [] -%>
class <%= class_name %>Resource < ApplicationResource
<% if primary_key_type -%>
  attribute :id, :<%= primary_key_type %>, readable: true, writable: false, filterable: true

<% end -%>
<%
  attributes.each do |attribute|
    name = attribute.name
    type = attribute.type
    unless Graphiti::Types.map.keys.include? type
      type = case type
        when :belongs_to, :references
          belongs_to << name
          type = name.camelcase.constantize.columns_hash["id"].type rescue nil
          type ||= primary_key_type || :integer
          name += '_id'
          type
        when :text
          type = :string
      end
    end
-%>
  attribute :<%= name %>, :<%= type %>, readable: true, writable: false
<% end -%>
<% if belongs_to.present? -%>

<%   belongs_to.each do |name| -%>
  belongs_to :<%= name %>
<%   end -%>
<% end -%>
end
