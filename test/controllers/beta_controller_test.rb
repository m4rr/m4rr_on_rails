require 'test_helper'

class BetaControllerTest < ActionController::TestCase
  setup do
    @betum = beta(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:beta)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create betum" do
    assert_difference('Betum.count') do
      post :create, betum: { desc: @betum.desc, email: @betum.email, first_name: @betum.first_name, last_name: @betum.last_name }
    end

    assert_redirected_to betum_path(assigns(:betum))
  end

  test "should show betum" do
    get :show, id: @betum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @betum
    assert_response :success
  end

  test "should update betum" do
    patch :update, id: @betum, betum: { desc: @betum.desc, email: @betum.email, first_name: @betum.first_name, last_name: @betum.last_name }
    assert_redirected_to betum_path(assigns(:betum))
  end

  test "should destroy betum" do
    assert_difference('Betum.count', -1) do
      delete :destroy, id: @betum
    end

    assert_redirected_to beta_path
  end
end
