###############################################################################
# Bootstrap is a business requirement from the application's design specs,
#  and is therefore covered by tests.
###############################################################################

require 'test_helper'

class BootstrapAddedTest < ActionDispatch::IntegrationTest

  # Tests that the homepage has Bootstrap JS
  test 'Homepage Has Bootstrap JS Files' do
    get root_path

    assert_select 'script', :src => /bootstrap\//,         :minimum => 1
    assert_select 'script', :src => /bootstrap-sprockets/, :minimum => 1, :maximum => 1
  end

  # Tests that the homepage has the applicationcustom.scss file, which 
  #  loads Bootstrap styles
  test 'Homepage Has ApplicationCustom SCSS File' do
    get root_path

    assert_select 'link', :rel => 'stylesheet', :href => /applicationcustom\.scss/, :minimum => 1, :maximum => 1
  end

  # Tests that applicationcustom.scss contains Bootstrap styles.
  # Warning: The string 'bootstrap' itself only appears as a local font url
  #  path, and may be brittle. Testing for the string 'glyphicon' may be more
  #  reliable in determening the presence of Bootstrap CSS styles.
  test 'ApplicationCustom SCSS Contains Bootstrap Styles' do
    get '/assets/applicationcustom.scss'

    body = response.body.to_s

    assert_equal 200,         response.status
    assert_equal Mime::CSS,   response.content_type
    assert_match /bootstrap/, body
    assert_match /glyphicon/, body
  end

end
