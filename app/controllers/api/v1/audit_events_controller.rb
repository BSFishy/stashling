module Api
  module V1
    class AuditEventsController < BaseController
      before_action :set_audit_event, only: %i[show update destroy]

      def index
        render_resource AuditEvent.all
      end

      def show
        render_resource @audit_event
      end

      def create
        audit_event = AuditEvent.new(audit_event_params)
        if audit_event.save
          render_resource audit_event, status: :created
        else
          render_errors audit_event
        end
      end

      def update
        if @audit_event.update(audit_event_params)
          render_resource @audit_event
        else
          render_errors @audit_event
        end
      end

      def destroy
        @audit_event.destroy
        head :no_content
      end

      private

      def set_audit_event
        @audit_event = AuditEvent.find(params[:id])
      end

      def audit_event_params
        params.require(:audit_event).permit(
          :entity_type,
          :entity_id,
          :action,
          :actor,
          before: {},
          after: {}
        )
      end
    end
  end
end
