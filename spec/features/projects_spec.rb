require 'rails_helper'

# Projects spec
RSpec.feature "Projects", type: :feature do
  context "Create new project while signed in" do

    # Create a test account beforehand
    before(:each) do
      visit new_user_registration_path
      fill_in "user_email", with: "test@email.com"
      fill_in "user_password", with: "password"
      fill_in "user_password_confirmation", with: "password"
      click_button "Sign up"
    end

    # Delete test account afterward
    after(:each) do
      visit cancel_user_registration_path
    end

    # Title and Description are filled in so therefore the project should be created successfully
    scenario "should be successful" do
      visit new_project_path
      fill_in "project_title", with: "Test title"
      fill_in "project_description", with: "Test description"
      click_button "Create Project"
      expect(page).to have_content("Project was successfully created")
    end

    # Description is not filled in so therefore the project creation should be unsuccessful
    scenario "should fail" do
      visit new_project_path
      fill_in "project_title", with: "Test title"
      click_button "Create Project"
      expect(page).to have_content("Description can't be blank")
    end
  end

  # Not signed in so the new project path should redirect to a sign-in/sign-up page
  context "Create new project while signed out" do
    scenario "should fail" do
      visit new_project_path
      expect(page).to have_content("You must sign in to create projects")
    end
  end

  context "Update project while signed in" do
    let(:project) { Project.create(title: "Test title", description: "Test content") }

    # Create a test account beforehand
    before(:each) do
      visit new_user_registration_path
      fill_in "user_email", with: "test@email.com"
      fill_in "user_password", with: "password"
      fill_in "user_password_confirmation", with: "password"
      click_button "Sign up"
    end

    # Delete test account afterward
    after(:each) do
      visit cancel_user_registration_path
    end

    scenario "should be successful" do
      visit edit_project_path(project)
      fill_in "project_description", with: "New description content"
      click_button "Update Project"
      expect(page).to have_content("Project was successfully updated")
    end

    scenario "should fail" do
      visit edit_project_path(project)
      fill_in "project_description", with: ""
      click_button "Update Project"
      expect(page).to have_content("Description can't be blank")
    end
  end

  # Not signed in so the edit project path should redirect to a sign-in/sign-up page
  context "Update project while signed out" do
    let(:project) { Project.create(title: "Test title", description: "Test content") }

    scenario "should fail" do
      visit edit_project_path(project)
      expect(page).to have_content("You must sign in to edit projects")
    end
  end

  # Deleting a project while signed in
  context "Remove existing project while signed in" do
    let!(:project) { Project.create(title: "Test title", description: "Test content") }

    # Create a test account beforehand
    before(:each) do
      visit new_user_registration_path
      fill_in "user_email", with: "test@email.com"
      fill_in "user_password", with: "password"
      fill_in "user_password_confirmation", with: "password"
      click_button "Sign up"
    end

    # Delete test account afterward
    after(:each) do
      visit cancel_user_registration_path
    end

    scenario "should be successful" do
      visit projects_path
      click_link "Delete"
      expect(page).to have_content("Project was successfully destroyed")
      expect(Project.count).to eq(0)
    end
  end

=begin  DONT USE THIS TEST ANYMORE, DELETE BUTTON IS NOT AVAILABLE TO CLICK FOR UNAUTHORIZED USERS

  # Deleting a project while signed out
  context "Remove existing project while signed out" do
    let!(:project) { Project.create(title: "Test title", description: "Test content") }
    scenario "should fail" do
      visit projects_path
      click_link "Delete"
      expect(page).to have_content("Unsuccessful. You must sign in to destroy projects")
      expect(Project.count).to eq(1)
    end
  end
  
=end 

end
