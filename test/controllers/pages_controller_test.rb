require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest

  test "should generate home route" do
    assert_routing '/', controller: 'pages', action: 'home'
  end

  test "should generate about route" do
    assert_routing '/about', controller: 'pages', action: 'about'
  end

  test "should generate validate route" do
    assert_routing({ method: 'post', path: '/validate' }, { controller: "pages", action: "validate" })
  end

end
