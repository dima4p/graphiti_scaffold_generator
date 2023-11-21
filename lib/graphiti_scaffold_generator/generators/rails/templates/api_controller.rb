<% resource = class_name + 'Resource' -%>
<% pundit = defined?(Pundit) -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < GraphitiApiController
  before_action :set_<%= pundit ? 'and_authorize_' : '' %><%= singular_table_name %>, only: %i[show update destroy]

  # GET <%= route_url %>
  def index
    authorize <%= class_name %>
    respond_with <%= resource %>.all(params)
  end

  # GET <%= route_url %>/1
  def show
    respond_with @<%= singular_table_name %>
  end

  # POST <%= route_url %>
  def create
    @<%= singular_table_name %> = <%= resource %>.build params
<% if pundit -%>
    authorize <%= orm_class.build(class_name, "#{singular_table_name}_params") %>
<% end -%>

    if @<%= singular_table_name %>.save
      render jsonapi: @<%= singular_table_name %>, status: :created
    else
      render jsonapi_errors: @<%= singular_table_name %>
    end
  end

  # PATCH/PUT <%= route_url %>/1
  def update
    if @<%= singular_table_name %>.update_attributes
      render jsonapi: @<%= singular_table_name %>
    else
      render jsonapi_errors: @<%= singular_table_name %>
    end
  end

  # DELETE <%= route_url %>/1
  def destroy
    @<%= orm_instance.destroy %>
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_<%= pundit ? 'and_authorize_' : '' %><%= singular_table_name %>
    @<%= singular_table_name %> = <%= resource %>.find(params)
<% if pundit -%>
    authorize @<%= singular_table_name %>.data
<% end -%>
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def <%= "#{singular_table_name}_params" %>
<%- if attributes_names.empty? -%>
    params.fetch(:<%= singular_table_name %>, {})
<%- else -%>
    list = %i[
      <%= attributes_names.join(' ') %>
    ]
    params.require(:data).require(:attributes).permit(*list)
<%- end -%>
  end
end
<% end -%>
