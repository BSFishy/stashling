class DashboardController < ApplicationController
  def index
    @accounts = Account.order(:name)

    @summary_stats = [
      { label: "Portfolio Value", value: "$0.00", hint: "Awaiting first valuation snapshot" },
      { label: "Cost Basis", value: "$0.00", hint: "Add a lot to establish basis" },
      { label: "Unrealized P/L", value: "$0.00", hint: "Refresh prices to see movement" }
    ]

    @account_glances =
      if @accounts.any?
        @accounts.map do |account|
          {
            name: account.name,
            institution: account.institution,
            value: "$0.00",
            cost_basis: "$0.00",
            unrealized: "$0.00"
          }
        end
      else
        [
          {
            name: "No accounts yet",
            institution: "Create one to unlock account-level analytics",
            value: "—",
            cost_basis: "—",
            unrealized: "—",
            placeholder: true
          }
        ]
      end

    @pipelines = [
      { title: "Lots", cta: "Add Lot", description: "Track every buy with quantity, unit cost, and tags." },
      { title: "Sales", cta: "Record Sale", description: "Allocate exits against specific lots for audit." },
      { title: "Imports", cta: "Upload CSV", description: "Bootstrap history with the guided import wizard." }
    ]

    @configuration_actions = [
      { label: "Add Account", description: "Define brokerage buckets, base currency, and institutions.", primary: true },
      { label: "Connect Price Sources", description: "Prioritize adapters and store API credentials securely." },
      { label: "Set Base Currency", description: "Choose the denomination used for all reports and charts." },
      { label: "Manage Tags", description: "Standardize strategy tags for filtering and reporting." }
    ]
  end
end
