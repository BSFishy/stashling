module Api
  module V1
    class LotsController < BaseController
      before_action :set_lot, only: %i[show update destroy]

      def index
        render_resource Lot.all
      end

      def show
        render_resource @lot
      end

      def create
        lot = Lot.new(lot_params)
        if lot.save
          render_resource lot, status: :created
        else
          render_errors lot
        end
      end

      def update
        if @lot.update(lot_params)
          render_resource @lot
        else
          render_errors @lot
        end
      end

      def destroy
        @lot.destroy
        head :no_content
      end

      private

      def set_lot
        @lot = Lot.find(params[:id])
      end

      def lot_params
        params.require(:lot).permit(
          :asset_id,
          :account_id,
          :trade_date,
          :settle_date,
          :quantity,
          :unit_cost,
          :fees,
          :notes,
          tags: {}
        )
      end
    end
  end
end
