module Api
  module V1
    class BaseController < ApplicationController
      skip_forgery_protection

      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

      private

      def render_not_found
        head :not_found
      end

      def render_resource(resource, status: :ok)
        render json: resource, status: status
      end

      def render_errors(resource, status: :unprocessable_entity)
        render json: { errors: resource.errors.full_messages }, status: status
      end
    end
  end
end
