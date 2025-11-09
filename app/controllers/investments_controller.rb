class InvestmentsController < ApplicationController
  before_action :set_investment, only: %i[ show edit update destroy ]
  def index
    @investments = Investment.all
  end

  def show
  end

  def new
    @investment = Investment.new
  end

  def create
    @investment = Investment.new(investment_params)
    if @investment.save
      redirect_to @investment
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @investment.update(investment_params)
      redirect_to @investment
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @investment.destroy
    redirect_to investments_path
  end

  private
    def set_investment
      @investment = Investment.find(params[:id])
    end

    def investment_params
      params.expect(investment: [ :ticker, :amount ])
    end
end
