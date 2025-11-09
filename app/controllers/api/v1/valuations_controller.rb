module Api
  module V1
    class ValuationsController < BaseController
      before_action :set_valuation, only: %i[show update destroy]

      def index
        render_resource Valuation.all
      end

      def show
        render_resource @valuation
      end

      def create
        valuation = Valuation.new(valuation_params)
        if valuation.save
          render_resource valuation, status: :created
        else
          render_errors valuation
        end
      end

      def update
        if @valuation.update(valuation_params)
          render_resource @valuation
        else
          render_errors @valuation
        end
      end

      def destroy
        @valuation.destroy
        head :no_content
      end

      private

      def set_valuation
        @valuation = Valuation.find(params[:id])
      end

      def valuation_params
        params.require(:valuation).permit(
          :asset_id,
          :lot_id,
          :price,
          :as_of,
          :source,
          metrics: {}
        )
      end
    end
  end
end
