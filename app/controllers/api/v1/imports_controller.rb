module Api
  module V1
    class ImportsController < BaseController
      before_action :set_import, only: %i[show update destroy]

      def index
        render_resource Import.all
      end

      def show
        render_resource @import
      end

      def create
        import = Import.new(import_params)
        if import.save
          render_resource import, status: :created
        else
          render_errors import
        end
      end

      def update
        if @import.update(import_params)
          render_resource @import
        else
          render_errors @import
        end
      end

      def destroy
        @import.destroy
        head :no_content
      end

      private

      def set_import
        @import = Import.find(params[:id])
      end

      def import_params
        params.require(:import).permit(:filename, :status, :error_log, payload: {})
      end
    end
  end
end
