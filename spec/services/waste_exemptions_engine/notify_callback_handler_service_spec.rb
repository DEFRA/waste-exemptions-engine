# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NotifyCallbackHandlerService do
    let(:registration) { create(:registration) }
    let(:communication_log) do
      log = create(:communication_log, notification_id: notification_id, status: "sent")
      registration.communication_logs << log
      log
    end
    let(:notification_id) { "740e5834-3a29-46b4-9a6f-16142fde533a" }

    describe ".run" do
      context "with a delivery receipt callback" do
        let(:payload) do
          {
            "id" => notification_id,
            "reference" => "WEX999999",
            "to" => "recipient@example.com",
            "status" => "delivered",
            "notification_type" => "email"
          }
        end

        before { communication_log }

        it "updates the communication log status" do
          expect { described_class.run(payload) }
            .to change { communication_log.reload.status }
            .from("sent")
            .to("delivered")
        end

        it "returns the notification_id and new status" do
          result = described_class.run(payload)

          expect(result).to eq(notification_id: notification_id, status: "delivered")
        end

        %w[permanent-failure temporary-failure technical-failure].each do |status|
          context "when status is #{status}" do
            let(:payload) do
              {
                "id" => notification_id,
                "status" => status,
                "notification_type" => "email"
              }
            end

            it "updates the communication log status to #{status}" do
              expect { described_class.run(payload) }
                .to change { communication_log.reload.status }
                .from("sent")
                .to(status)
            end
          end
        end

        context "when the communication log is not found" do
          let(:payload) do
            {
              "id" => "unknown-uuid",
              "status" => "delivered",
              "notification_type" => "email"
            }
          end

          it "returns not_found status" do
            result = described_class.run(payload)

            expect(result).to eq(notification_id: "unknown-uuid", status: "not_found")
          end

          it "logs a warning" do
            allow(Rails.logger).to receive(:warn)

            described_class.run(payload)

            expect(Rails.logger).to have_received(:warn).with(/not found/)
          end
        end

        context "when the communication log already has a terminal status" do
          before { communication_log.update!(status: "delivered") }

          it "does not change the status" do
            expect { described_class.run(payload) }
              .not_to change { communication_log.reload.status }
          end

          it "returns the existing terminal status" do
            result = described_class.run(payload)

            expect(result).to eq(notification_id: notification_id, status: "delivered")
          end
        end

        context "when id is missing" do
          let(:payload) { { "status" => "delivered", "notification_type" => "email" } }

          it "raises an ArgumentError" do
            expect { described_class.run(payload) }.to raise_error(ArgumentError, /Missing id/)
          end
        end

        context "when status is missing" do
          let(:payload) { { "id" => notification_id, "notification_type" => "email" } }

          it "raises an ArgumentError" do
            expect { described_class.run(payload) }.to raise_error(ArgumentError, /Missing status/)
          end
        end
      end

      context "with a returned letter callback" do
        let(:payload) do
          {
            "notification_id" => notification_id,
            "reference" => "WEX999999",
            "date_sent" => "2026-05-14T12:15:30.000000Z",
            "template_name" => "confirmation_letter",
            "template_id" => "f33517ff-2a88-4f6e-b855-c550268ce08a",
            "template_version" => 1
          }
        end

        before { communication_log }

        it "updates the communication log status to returned" do
          expect { described_class.run(payload) }
            .to change { communication_log.reload.status }
            .from("sent")
            .to("returned")
        end

        it "returns the notification_id and returned status" do
          result = described_class.run(payload)

          expect(result).to eq(notification_id: notification_id, status: "returned")
        end

        context "when notification_id is blank" do
          let(:payload) { { "notification_id" => "", "template_name" => "confirmation_letter" } }

          it "raises an ArgumentError" do
            expect { described_class.run(payload) }.to raise_error(ArgumentError, /Missing notification_id/)
          end
        end
      end

      context "with an unrecognised payload" do
        let(:payload) { { "foo" => "bar" } }

        it "raises an ArgumentError" do
          expect { described_class.run(payload) }.to raise_error(ArgumentError, /Unrecognised/)
        end
      end
    end
  end
end
