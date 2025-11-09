module Api
  module V1
    class PriceSourcesController < BaseController
      before_action :set_price_source, only: %i[show update destroy]

      def index
        render_resource PriceSource.all
      end

      def show
        render_resource @price_source
      end

      def create
        price_source = PriceSource.new(price_source_params)
        if price_source.save
          render_resource price_source, status: :created
        else
          render_errors price_source
        end
      end

      def update
        if @price_source.update(price_source_params)
          render_resource @price_source
        else
          render_errors @price_source
        end
      end

      def destroy
        @price_source.destroy
        head :no_content
      end

      private

      def set_price_source
        @price_source = PriceSource.find(params[:id])
      end

      def price_source_params
        params.require(:price_source).permit(:name, :adapter_type, credentials: {})
      end
    end
  end
end
