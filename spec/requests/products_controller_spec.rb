require 'rails_helper'

RSpec.describe V1::ProductsController do
  before(:each) do
    allow_any_instance_of(V1::ProductsController).to receive(:api_authenticate).and_return(true)
  end

  it "should list all products" do
    2.times{ create(:product) }
    get '/products', nil, {'Accept' => 'application/agh.edu.pl; version=1'}
    assert_response 200
    expect(response_body["products"].size).to eq 2
  end

  it "should show details of the product" do
    product = create(:product)
    get product_url(product), nil, {'Accept' => 'application/agh.edu.pl; version=1'}
    assert_response 200
  end    

  it "should create new product" do
    mock_data = { product: { 
        name: "Product Test",
        price: 1.22,
        category: create(:category) 
      }
    }
    
    post '/products', mock_data, {'Accept' => 'application/agh.edu.pl; version=1'}
    assert_response 201
    current_product = response_body["product"]
    expect(current_product["name"]).to eq "Product Test"
  end

  it "should update existing product" do
    product = create(:product)

    mock_data = { product: { 
        name: "Updated Test Product"
      }
    }
    patch product_url(product), mock_data, {'Accept' => 'application/agh.edu.pl; version=1'}
    assert_response 200
    current_product = response_body["product"]
    expect(current_product["name"]).to eq "Updated Test Product"
  end

  it 'should does nothing when the product does NOT exist' do  
    product = create(:product)
    delete product_url(rand(100..1000)), nil, {'Accept' => 'application/agh.edu.pl; version=1'}
    assert_response 404
  end


  it 'should delete the product' do
    product = create(:product)
    delete product_url(product), nil, {'Accept' => 'application/agh.edu.pl; version=1'}
    assert_response 204
    expect(Product.find_by(id: product.id)).to eql(nil)
  end

  def response_body
    JSON.parse(response.body)
  end
end