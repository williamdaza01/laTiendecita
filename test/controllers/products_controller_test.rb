require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "render a list of products" do
    get products_path
    assert_response :success
    assert_select '.product', 3
    assert_select '.category', 3
  end

  test "render a list of products filter by category" do
    get products_path(category_id: categories(:computers).id)
    assert_response :success
    assert_select '.product', 1
  end

  test "render a detailed product page" do
    get product_path(products(:ps4))
    assert_response :success
    assert_select '.title', 'PS4'
    assert_select '.description', 'PS4 linda'
    assert_select '.price', '150$'
  end

  test 'render a new product form' do
    get new_product_path
    assert_response :success
    assert_select 'form'
  end

  test 'does not allow to create a new product with empty fields' do
    post products_path params: {
      product: {
        title: '',
        description: 'control malo',
        price: 120,
      }
    }

    assert_response :unprocessable_entity
  end

  test 'allow to create a new product' do
    post products_path params: {
      product: {
        title: 'Xbox',
        description: 'control malo',
        price: 120,
        category_id: categories(:videogames)
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Producto agregado correctamente'
  end

  test 'render a edit product form' do
    get edit_product_path(products(:ps4))
    assert_response :success
    assert_select 'form'
  end

  test 'allow to update a product' do
    patch product_path(products(:ps4)), params: {
      product: {
        price: 220
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Producto actualizado correctamente'
  end

  test 'does not allow to update a new product with empty fields' do
    patch product_path(products(:ps4)), params: {
      product: {
        price: nil
      }
    }

    assert_response :unprocessable_entity
  end

  test 'can delete products' do
    assert_difference('Product.count', -1) do
      delete product_path(products(:ps4))
    end
    
    assert_redirected_to products_path
    assert_equal flash[:notice], 'Producto eliminado correctamente'
  end
end
