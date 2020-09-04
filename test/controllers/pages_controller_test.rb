require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest

  # Route Tests
  test "should generate home route" do
    assert_routing '/', controller: 'pages', action: 'home'
  end

  test "should generate about route" do
    assert_routing '/about', controller: 'pages', action: 'about'
  end

  test "should generate validate route" do
    assert_routing({ method: 'post', path: '/validate' }, { controller: "pages", action: "validate" })
  end

  # Action Tests
  test "should use home action" do
    get root_url
    assert_equal "home", @controller.action_name
    assert_equal "utf-8", @response.charset
    assert_equal "text/html; charset=utf-8", @response.content_type
    assert_equal 200, @response.status
  end

  test "should use about action" do
    get about_url
    assert_equal "about", @controller.action_name
    assert_equal 200, @response.status
  end

  test "should use validate action" do
    post validate_url, params: { validate: { country: "AU", tax_id: "11 111 111 111" } }
    assert_equal "validate", @controller.action_name
    assert_equal 302, @response.status
  end

  # Flash Message Tests
  test "Should generate Australian flash notice" do

    post validate_url, params: { validate: { country: "AU", tax_id: "51 824 753 556" } }
    assert_redirected_to root_path
    assert_equal "ABN Number 51 824 753 556 is a valid Tax ID.", flash[:notice]

  end

  test "Should generate Australian flash alert" do

    post validate_url, params: { validate: { country: "AU", tax_id: "11 111 111 111" } }
    assert_redirected_to root_path
    assert_equal "ABN Number 11 111 111 111 is not a valid Tax ID.", flash[:alert]

  end

  test "Should generate EU flash notice" do

    post validate_url, params: { validate: { country: "IE", tax_id: "IE6388047V" } }
    assert_redirected_to root_path
    assert_equal "IE: VAT Number IE6388047V is a valid Tax ID.", flash[:notice]

  end

  test "Should generate EU flash alert" do

    post validate_url, params: { validate: { country: "DE", tax_id: "DE345789003" } }
    assert_redirected_to root_path
    assert_equal "DE: VAT Number DE345789003 is not a valid Tax ID.", flash[:alert]

  end

  # Don't have a valid South African VAT
  # test "Should generate South African flash notice" do
  #
  #   post validate_url, params: { validate: { country: "ZA", tax_id: "??????????" } }
  #   assert_redirected_to root_path
  #   assert_equal "ZA: VAT Number ?????????? is not a valid Tax ID.", flash[:notice]
  #
  # end

  test "Should generate South African flash alert" do

    post validate_url, params: { validate: { country: "ZA", tax_id: "4023340283" } }
    assert_redirected_to root_path
    assert_equal "ZA: VAT Number 4023340283 is not a valid Tax ID.", flash[:alert]

  end

  test "Should generate an unsupported country flash message" do

    post validate_url, params: { validate: { country: "AF", tax_id: "12345678" } }
    assert_redirected_to root_path
    assert_equal "The Tax ID Validator currently doesn't support that country.", flash[:unsupported]

  end

  test "Should generate an required fields flash message" do

    post validate_url, params: { validate: { country: "", tax_id: "" } }
    assert_redirected_to root_path
    assert_equal "Both the Country and Tax ID fields are required.", flash[:alert]

  end

end
