require "rails_helper"  

RSpec.describe "Smoke Test", type: :system do  
  it "redirige a login desde la raíz" do  
    visit root_path  
    expect(page).to have_current_path(new_user_session_path)  
  end  
end  
