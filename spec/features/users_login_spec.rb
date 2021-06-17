require 'rails_helper'

RSpec.feature "UsersLogin", type: :feature do
  scenario "user login and logout the app", js: true do
    user = FactoryBot.create(:user)
    expect(user).to be_valid
    
    visit login_path
    
    expect(page).to have_content "ログイン"
    click_button "ログイン"
    
    expect(page).to have_content "invalid email or password"
    visit root_path
    expect(page).to_not have_content "invalid email or password"
    
    log_in_as(user)
    
    expect(page).to have_content "brian"
    expect(page).to_not have_content "ログイン"
    expect(page).to have_content "アカウント"
    
    find(".dropdown-toggle").click
    expect(page).to have_link "プロフィール"
    expect(page).to have_link "ログアウト"
    
    find('a', text: 'プロフィール').click
    expect(current_path).to eq user_path(user)
    
    # find(".dropdown-toggle").click
    click_link "アカウント"
    expect(page).to have_link "ランキング"
    
    click_link "ログアウト"
    sleep 4
    # find(:xpath, "//a[@href='/logout']").click
    # find('.dropdown-item', text: 'ログアウト').click
    expect(page).to have_content "ログイン"
    expect(page).to_not have_content "アカウント"
    # expect(current_path).to eq root_path
    
  end
  
  scenario "login with a valid email and a invalid password" do
    user = FactoryBot.create(:user)
    
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "invalid"
    
    click_button "ログイン"
    
    expect(current_path).to eq login_path
    expect(page).to have_content "invalid email or password"
    
    visit root_path
    expect(page).to_not have_content "invalid email or password"
    
  end
end
