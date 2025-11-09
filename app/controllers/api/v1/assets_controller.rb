module Api
  module V1
    class AssetsController < BaseController
      before_action :set_asset, only: %i[show update destroy]

      def index
        render_resource Asset.all
      end

      def show
        render_resource @asset
      end

      def create
        asset = Asset.new(asset_params)
        if asset.save
          render_resource asset, status: :created
        else
          render_errors asset
        end
      end

      def update
        if @asset.update(asset_params)
          render_resource @asset
        else
          render_errors @asset
        end
      end

      def destroy
        @asset.destroy
        head :no_content
      end

      private

      def set_asset
        @asset = Asset.find(params[:id])
      end

      def asset_params
        params.require(:asset).permit(:ticker, :security_type, :currency, :display_name)
      end
    end
  end
end
