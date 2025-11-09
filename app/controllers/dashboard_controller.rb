class DashboardController < ApplicationController
  def index
    @summary_stats = [
      { label: "Portfolio Value", value: "$0.00", hint: "Awaiting first valuation snapshot" },
      { label: "Cost Basis", value: "$0.00", hint: "Add a lot to establish basis" },
      { label: "Unrealized P/L", value: "$0.00", hint: "Refresh prices to see movement" }
    ]

    @pipelines = [
      { title: "Lots", cta: "Add Lot", description: "Track every buy with quantity, unit cost, and tags." },
      { title: "Sales", cta: "Record Sale", description: "Allocate exits against specific lots for audit." },
      { title: "Imports", cta: "Upload CSV", description: "Bootstrap history with the guided import wizard." }
    ]
  end
end
