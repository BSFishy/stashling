module Api
  module V1
    class AccountsController < BaseController
      before_action :set_account, only: %i[show update destroy]

      def index
        render_resource Account.all
      end

      def show
        render_resource @account
      end

      def create
        account = Account.new(account_params)
        if account.save
          render_resource account, status: :created
        else
          render_errors account
        end
      end

      def update
        if @account.update(account_params)
          render_resource @account
        else
          render_errors @account
        end
      end

      def destroy
        @account.destroy
        head :no_content
      end

      private

      def set_account
        @account = Account.find(params[:id])
      end

      def account_params
        params.require(:account).permit(:name, :institution, :base_currency)
      end
    end
  end
end
