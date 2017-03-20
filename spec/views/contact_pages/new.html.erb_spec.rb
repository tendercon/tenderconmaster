require 'rails_helper'

RSpec.describe "contact_pages/new", type: :view do
  before(:each) do
    assign(:contact_page, ContactPage.new())
  end

  it "renders new contact_page form" do
    render

    assert_select "form[action=?][method=?]", contact_pages_path, "post" do
    end
  end
end
