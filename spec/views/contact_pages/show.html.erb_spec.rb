require 'rails_helper'

RSpec.describe "contact_pages/show", type: :view do
  before(:each) do
    @contact_page = assign(:contact_page, ContactPage.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
