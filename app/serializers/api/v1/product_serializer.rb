class Api::V1::ProductSerializer < Api::V1::BaseSerializer
  attributes :id, :name, :category_name

  has_one :category

  def category_name
    object.category.try(:name)
  end
end