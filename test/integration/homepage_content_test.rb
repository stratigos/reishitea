require 'test_helper'

class HomepageContentTest < ActionDispatch::IntegrationTest
  # Tests that the homepage loads, has correct content-type, contains nav
  #  links, contains 'hero image', has sidebar, has an order form, and uses
  #  the expected index template.
  test 'Homepage Has Expected Content' do
    get root_path

    assert_equal    200,             response.status
    assert_equal    Mime::HTML,      response.content_type
    assert_select   'a[href=?]',     root_path, count: 2 # logo and nav
    assert_select   'a[href=?]',     about_path
    assert_select   'a[href=?]',     info_path
    assert_select   'a[href=?]',     orders_root_path
    assert_select   'form',          1
    assert_select   'input[type=?]', 'text',    count: 2
    assert_select   'button',        1
    assert_select   'img',           :src   => /reishi/
    assert_select   'div',           :class => /sidebar/
    assert_template 'welcome/index'
  end
end
