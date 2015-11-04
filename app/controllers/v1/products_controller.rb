class V1::ProductsController < V1::BaseController
  def index
    products = paginate(Product.all)
    
    render(
      json: ActiveModel::ArraySerializer.new(
        products,
        each_serializer: Api::V1::ProductSerializer,
        root: 'products',
        meta: meta_attributes(products)
      )
    )
  end

  def show
    product = Product.find(params[:id])
    render json: Api::V1::ProductSerializer.new(product).to_json
  end

  def create
    product = Product.new(create_params)
    return api_error(status: 422, errors: product.errors) unless product.valid?

    product.save!

    render(
      json: Api::V1::ProductSerializer.new(product).to_json,
      status: 201,
      location: product_path(product),
      serializer: Api::V1::ProductSerializer
    )
  end

  def update
    product = Product.find(params[:id])

    if !product.update_attributes(update_params)
      return api_error(status: 422, errors: product.errors)
    end

    render(
      json: Api::V1::ProductSerializer.new(product).to_json,
      status: 200,
      location: product_path(product.id),
      serializer: Api::V1::ProductSerializer
    )
  end

  def destroy
    product = Product.find_by(id: params[:id])
    return api_error(status: 404) if product.blank?
    
    if !product.destroy
      return api_error(status: 500)
    end

    head status: 204
  end

  private

    def create_params
      params.require(:product).permit(:name, :category_id, :price)
    end

    def update_params
      create_params
    end
end
