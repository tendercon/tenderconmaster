require 'rails_helper'

RSpec.describe "contact_pages/edit", type: :view do
  before(:each) do
    @contact_page = assign(:contact_page, ContactPage.create!())
  end

  it "renders the edit contact_page form" do
    render

    assert_select "form[action=?][method=?]", contact_page_path(@contact_page), "post" do
    end
  end
end
