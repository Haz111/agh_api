include ActionController::Serialization

class V1::BaseController < ActionController::API
  before_filter :api_authenticate

  rescue_from ActiveRecord::RecordNotFound, with: :not_found!

  def api_error(status: 500, errors: [])
    unless Rails.env.production?
      puts errors.full_messages if errors.respond_to? :full_messages
    end
    head status: status and return if errors.empty?

    render json: jsonapi_format(errors).to_json, status: status
  end

  def invalid_resource!(errors = [])
    api_error(status: 422, errors: errors)
  end

  def not_found!
    return api_error(status: 404, errors: 'Not found')
  end

  def paginate(resource)
    resource = resource.page(params[:page] || 1)
    if params[:per_page]
      resource = resource.per_page(params[:per_page])
    end

    return resource
  end

  def meta_attributes(object)
    {
      current_page: object.current_page,
      next_page: object.next_page,
      prev_page: object.prev_page,
      total_pages: object.total_pages,
      total_count: object.count
    }
  end

  protected

    def api_authenticate
      @current_account = Account.find_by_access_id(ApiAuth.access_id(request))
      if !@current_account.nil? && ApiAuth.authentic?(request, @current_account.authentication_token)
        return true
      else
        return unauthenticated!
      end
    end

    def unauthenticated!
      response.headers['WWW-Authenticate'] = "Token realm=Application"
      render json: { error: 'Bad credentials' }, status: 401
    end

    def jsonapi_format(errors)
      return errors if errors.is_a? String
      errors_hash = {}
      errors.messages.each do |attribute, error|
        array_hash = []
        error.each do |e|
          array_hash << {attribute: attribute, message: e}
        end
        errors_hash.merge!({ attribute => array_hash })
      end

      return errors_hash
    end
end
