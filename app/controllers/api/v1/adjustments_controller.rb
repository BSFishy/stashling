module Api
  module V1
    class AdjustmentsController < BaseController
      before_action :set_adjustment, only: %i[show update destroy]

      def index
        render_resource Adjustment.all
      end

      def show
        render_resource @adjustment
      end

      def create
        adjustment = Adjustment.new(adjustment_params)
        if adjustment.save
          render_resource adjustment, status: :created
        else
          render_errors adjustment
        end
      end

      def update
        if @adjustment.update(adjustment_params)
          render_resource @adjustment
        else
          render_errors @adjustment
        end
      end

      def destroy
        @adjustment.destroy
        head :no_content
      end

      private

      def set_adjustment
        @adjustment = Adjustment.find(params[:id])
      end

      def adjustment_params
        params.require(:adjustment).permit(
          :lot_id,
          :adjustment_type,
          :amount,
          :effective_date,
          :notes,
          metadata: {}
        )
      end
    end
  end
end
