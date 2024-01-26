# frozen_string_literal: true

RSpec.shared_examples "CanHaveCommunicationLog" do

  describe "CanHaveCommunicationLog" do

    describe "#create_log" do

      subject(:run_service) { service.run(**parameters) }

      let(:notifications_client) { instance_double(Notifications::Client) }
      let(:service) { service_class.new }

      before do
        allow(Notifications::Client).to receive(:new).and_return(notifications_client)
        allow(notifications_client).to receive(:send_email)
        allow(notifications_client).to receive(:send_letter)
      end

      it { expect { run_service }.not_to raise_error }

      it { expect { run_service }.to change(WasteExemptionsEngine::CommunicationLog, :count).by(1) }

      it "populates the expected values" do
        run_service

        log_instance = WasteExemptionsEngine::CommunicationLog.first

        aggregate_failures do
          expect(log_instance.message_type).to eq service.communications_log_params[:message_type]
          expect(log_instance.template_id).to eq service.communications_log_params[:template_id]
          expect(log_instance.template_label).to eq service.communications_log_params[:template_label]
          expect(log_instance.sent_to).to eq service.communications_log_params[:sent_to]
        end
      end

      it "message type and label match" do
        run_service

        log_instance = WasteExemptionsEngine::CommunicationLog.first

        expect(log_instance.template_label).to end_with(log_instance.message_type)
      end
    end
  end
end
