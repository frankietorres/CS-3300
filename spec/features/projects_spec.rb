require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  context "Create new project while signed in" do

    # Create a test account beforehand
    before(:all) do
      visit new_user_registration_path
      fill_in "user_email", with: "test@email.com"
      fill_in "user_password", with: "password"
      fill_in "user_password_confirmation", with: "password"
      click_button "Sign up"
    end

    # Delete the test account after all tests are run
    after(:all) do 
      visit edit_user_registration_path
      click_button "Cancel my acccount"
    end

    # Title and Description are filled in so therefore the project should be created successfully
    scenario "should be successful" do
      visit new_project_path
      fill_in "Title", with: "Test title"
      fill_in "Description", with: "Test description"
      click_button "Create Project"
      expect(page).to have_content("Project was successfully created")
    end

    # Description is not filled in so therefore the project creation should be unsuccessful
    scenario "should fail" do
      visit new_project_path
      fill_in "Title", with: "Test title"
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
    before(:all) do
      visit new_user_registration_path
      fill_in "user_email", with: "test@email.com"
      fill_in "user_password", with: "password"
      fill_in "user_password_confirmation", with: "password"
      click_button "Sign up"
    end

    before(:each) do
      visit edit_project_path(project)
    end

    # Delete the test account after all tests are run
    after(:all) do 
      visit edit_user_registration_path
      click_button "Cancel my acccount"
    end

    scenario "should be successful" do
      within("form") do
        fill_in "Description", with: "New description content"
      end
      click_button "Update Project"
      expect(page).to have_content("Project was successfully updated")
    end

    scenario "should fail" do
      within("form") do
        fill_in "Description", with: ""
      end
      click_button "Update Project"
      expect(page).to have_content("Description can't be blank")
    end
  end

  # Not signed in so the edit project path should redirect to a sign-in/sign-up page
  context "Update project while signed out" do
    scenario "should fail" do
      visit edit_project_path
      expect(page).to have_content("You must sign in to edit projects")
    end
  end

  # Deleting a project while signed in
  context "Remove existing project" do
    let!(:project) { Project.create(title: "Test title", description: "Test content") }
    scenario "remove project" do
      visit projects_path
      click_link "Destroy"
      expect(page).to have_content("Project was successfully destroyed")
      expect(Project.count).to eq(0)
    end
  end

  # Deleting a project while signed out
  context "Remove existing project" do
    let!(:project) { Project.create(title: "Test title", description: "Test content") }
    scenario "remove project" do
      visit projects_path
      click_link "Destroy"
      expect(page).to have_content("Project was successfully destroyed")
      expect(Project.count).to eq(0)
    end
  end

end
