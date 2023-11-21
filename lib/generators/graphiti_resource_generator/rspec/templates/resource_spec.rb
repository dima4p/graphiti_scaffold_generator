<%
  primary_key_type = Rails.application.config.generators
      .options[:active_record][:primary_key_type]
  belongs_to = []
  id_attr = []; id_attr << ['id', primary_key_type.inspect] if primary_key_type
  all_attributes = attributes.map do |attribute|
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
  [name, type.inspect]
  end
  all_attributes = id_attr + all_attributes
-%>
<% if File.exist?(File.join %w[spec rails_helper.rb]) -%>
require 'rails_helper'
<% else -%>
require 'spec_helper'
<% end -%>

describe '<%= class_name %>Resource', type: :resource do
  subject(:config) { <%= class_name %>Resource.config }

  describe 'attributes' do
    subject(:attributes) { config[:attributes] }

    it 'equal to [<%= all_attributes.map{|a| ":#{a.first}"}.join ", " %>]' do
      expect(attributes.keys)
          .to eq %i[
            <%= all_attributes.map(&:first).join "\n            " %>
          ]
    end
<% all_attributes.each do |name, type| -%>

    describe ':<%= name %>' do
      subject(:attr_<%= name %>) { attributes[:<%= name %>] }

      it 'has type <%= type %>' do
        expect(attr_<%= name %>[:type]).to be <%= type %>
      end

      it 'is <%= name == 'id' ? '' : 'not ' %>filterable' do
        expect(attr_<%= name %>[:filterable]).to be <%= name == 'id' %>
      end

      it 'is readable' do
        expect(attr_<%= name %>[:readable]).to be true
      end

      it 'is not writable' do
        expect(attr_<%= name %>[:writable]).to be false
      end

      it 'is not sortable' do
        expect(attr_<%= name %>[:sortable]).to be false
      end
    end
<% end -%>
  end

  describe 'relation' do
    subject(:relations) do
      config[:sideloads].each_with_object({}) do |(name, sideload), hash|
        hash[sideload.type] ||= []
        hash[sideload.type] << sideload.name
      end
    end

    describe '::belongs_to' do
      subject(:list) { relations[:belongs_to] }

<% if belongs_to.blank?  -%>
      it 'does not exist' do
        is_expected.to be_blank
      end
<% else -%>
<%   belongs_to.each_with_index do |name, n| -%>
<%     if n > 0 -%>

<%     end -%>
      it 'is defined for :<%= name %>' do
        expect(list).to include :<%= name %>
      end
<%   end -%>
<% end -%>
    end
<%
  %w[
    has_many
    has_one
    many_to_many
    polymorphic_belongs_to
    polymorphic_has_many
  ].each do |relation_name|
-%>

    describe '::<%= relation_name %>' do
      subject(:list) { relations[:<%= relation_name %>] }

      it 'does not exist' do
        is_expected.to be_blank
      end

      it 'is defined for :the_name_of_the_relation' do
        skip 'edit this Spec and add more if required or remove it completely'
        expect(list).to include :the_name_of_the_relation
      end
    end
<% end -%>
  end
end
