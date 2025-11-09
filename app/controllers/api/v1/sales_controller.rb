module Api
  module V1
    class SalesController < BaseController
      before_action :set_sale, only: %i[show update destroy]

      def index
        render_resource Sale.all
      end

      def show
        render_resource @sale
      end

      def create
        sale = Sale.new(sale_params)
        if sale.save
          render_resource sale, status: :created
        else
          render_errors sale
        end
      end

      def update
        if @sale.update(sale_params)
          render_resource @sale
        else
          render_errors @sale
        end
      end

      def destroy
        @sale.destroy
        head :no_content
      end

      private

      def set_sale
        @sale = Sale.find(params[:id])
      end

      def sale_params
        params.require(:sale).permit(
          :asset_id,
          :account_id,
          :trade_date,
          :total_quantity,
          :proceeds,
          :fees
        )
      end
    end
  end
end
