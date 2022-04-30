require 'rails_helper'

RSpec.feature User, type: :feature do
    context "Verifying user operations" do

        # Delete test account afterward
        after(:each) do
            visit cancel_user_registration_path
        end

        scenario "Successfully create a new user (sign up)" do
            visit new_user_registration_path
            fill_in "user_email", with: "test@email.com"
            fill_in "user_password", with: "password"
            fill_in "user_password_confirmation", with: "password"
            click_button "Sign up"
            expect(page).to have_content("Welcome! You have signed up successfully.")
        end
    end
end