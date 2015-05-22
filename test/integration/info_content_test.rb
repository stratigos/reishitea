require 'test_helper'

class InfoContentTest < ActionDispatch::IntegrationTest
  # Tests that the info-page loads, has correct content-type, contains nav
  #  links, has sidebar, and uses the expected info template.
  test 'Reishi Information Page Has Expected Content' do
    get info_path

    assert_equal    200,             response.status
    assert_equal    Mime::HTML,      response.content_type
    assert_select   'nav',           1
    assert_select   'div',           :class => /sidebar/
    assert_template 'welcome/info'
  end
end
