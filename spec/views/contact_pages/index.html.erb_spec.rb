require 'rails_helper'

RSpec.describe "contact_pages/index", type: :view do
  before(:each) do
    assign(:contact_pages, [
      ContactPage.create!(),
      ContactPage.create!()
    ])
  end

  it "renders a list of contact_pages" do
    render
  end
end
