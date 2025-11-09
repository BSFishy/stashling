module Api
  module V1
    class SaleAllocationsController < BaseController
      before_action :set_sale_allocation, only: %i[show update destroy]

      def index
        render_resource SaleAllocation.all
      end

      def show
        render_resource @sale_allocation
      end

      def create
        sale_allocation = SaleAllocation.new(sale_allocation_params)
        if sale_allocation.save
          render_resource sale_allocation, status: :created
        else
          render_errors sale_allocation
        end
      end

      def update
        if @sale_allocation.update(sale_allocation_params)
          render_resource @sale_allocation
        else
          render_errors @sale_allocation
        end
      end

      def destroy
        @sale_allocation.destroy
        head :no_content
      end

      private

      def set_sale_allocation
        @sale_allocation = SaleAllocation.find(params[:id])
      end

      def sale_allocation_params
        params.require(:sale_allocation).permit(
          :sale_id,
          :lot_id,
          :quantity,
          :realized_pl,
          cost_basis_snapshot: {}
        )
      end
    end
  end
end
