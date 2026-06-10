# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/MultipleExpectations
module WasteExemptionsEngine
  RSpec.describe SaveSiteAddressService do
    subject(:run_service) do
      described_class.run(
        transient_registration: transient_registration,
        address_attributes: address_attributes,
        mode: mode
      )
    end

    let(:transient_registration) { create(:new_charged_registration, is_multisite_registration: multisite) }
    let(:multisite) { false }
    let(:mode) { :lookup }
    let(:address_attributes) do
      {
        uprn: "340116",
        organisation: "T.B. & M.E. Hosking",
        premises: "Wootton Grounds Farm",
        street_address: "Lower Road",
        locality: "Haddenham",
        city: "Aylesbury",
        postcode: "HP17 8TP"
      }
    end

    before do
      allow(AssignSiteDetailsService).to receive(:run)
    end

    it "locks the transient registration while saving the site address" do
      allow(transient_registration).to receive(:with_lock).and_call_original

      run_service

      expect(transient_registration).to have_received(:with_lock)
    end

    context "when saving a single-site registration" do
      it "creates a site address when one does not already exist" do
        result = nil

        expect { result = run_service }
          .to change { transient_registration.transient_addresses.site.count }.from(0).to(1)

        site = transient_registration.reload.site_address

        aggregate_failures do
          expect(result).to be(true)
          expect(site.uprn).to eq("340116")
          expect(site.postcode).to eq("HP17 8TP")
          expect(site.mode).to eq("lookup")
          expect(site.address_type).to eq("site")
          expect(AssignSiteDetailsService).to have_received(:run).with(address: site).at_least(:once)
        end
      end

      context "when a site address already exists" do
        let!(:existing_site) do
          create(:transient_address, :site_using_grid_reference,
                 transient_registration: transient_registration,
                 grid_reference: "ST 11111 22222",
                 description: "Old site description",
                 area: "Old area")
        end

        it "updates the existing site address instead of creating another one" do
          result = nil

          expect { result = run_service }
            .not_to change { transient_registration.transient_addresses.site.count }

          aggregate_failures do
            expect(result).to be(true)
            expect(existing_site.reload.uprn).to eq("340116")
            expect(existing_site.postcode).to eq("HP17 8TP")
            expect(existing_site.mode).to eq("lookup")
          end
        end

        it "clears stale site location fields before saving the replacement address" do
          run_service

          aggregate_failures do
            expect(existing_site.reload.grid_reference).to be_nil
            expect(existing_site.description).to be_nil
            expect(existing_site.area).to be_nil
          end
        end
      end
    end

    context "when adding a site to a multisite registration" do
      let(:multisite) { true }

      it "creates a new site address" do
        result = nil

        expect { result = run_service }
          .to change { transient_registration.transient_addresses.site.count }.from(0).to(1)

        expect(result).to be(true)
      end

      context "when a lookup site with the same UPRN already exists" do
        let!(:existing_site) do
          create(:transient_address, :site_address,
                 transient_registration: transient_registration,
                 uprn: "340116",
                 premises: "Original premises",
                 mode: :lookup)
        end

        it "returns true without creating or changing a site address" do
          result = nil

          expect { result = run_service }
            .not_to change { transient_registration.transient_addresses.site.count }

          aggregate_failures do
            expect(result).to be(true)
            expect(existing_site.reload.premises).to eq("Original premises")
          end
        end
      end

      context "when a grid reference site with the same grid reference and description already exists" do
        let(:mode) { :auto }
        let(:address_attributes) do
          {
            grid_reference: "ST 12345 67890",
            description: "Waste stored in the north barn"
          }
        end

        before do
          create(:transient_address, :site_using_grid_reference,
                 transient_registration: transient_registration,
                 grid_reference: "ST 12345 67890",
                 description: "Waste stored in the north barn")
        end

        it "returns true without creating a duplicate site address" do
          result = nil

          expect { result = run_service }
            .not_to change { transient_registration.transient_addresses.site.count }

          expect(result).to be(true)
        end
      end

      context "when the same address fields already exist" do
        let(:mode) { :manual }
        let(:address_attributes) do
          {
            organisation: "T.B. & M.E. Hosking",
            premises: "Wootton Grounds Farm",
            street_address: "Lower Road",
            locality: "Haddenham",
            city: "Aylesbury",
            postcode: "HP17 8TP"
          }
        end

        before do
          create(:transient_address, :site_address,
                 transient_registration: transient_registration,
                 organisation: "T.B. & M.E. Hosking",
                 premises: "Wootton Grounds Farm",
                 street_address: "Lower Road",
                 locality: "Haddenham",
                 city: "Aylesbury",
                 postcode: "HP17 8TP",
                 mode: :manual)
        end

        it "returns true without creating a duplicate site address" do
          result = nil

          expect { result = run_service }
            .not_to change { transient_registration.transient_addresses.site.count }

          expect(result).to be(true)
        end
      end
    end

    context "when editing an existing site" do
      let(:multisite) { true }
      let(:mode) { :auto }
      let(:address_attributes) do
        {
          grid_reference: "ST 99999 88888",
          description: "Updated site description"
        }
      end
      let!(:site_to_edit) do
        create(:transient_address, :site_using_grid_reference,
               transient_registration: transient_registration,
               grid_reference: "ST 11111 22222",
               description: "Original site")
      end
      let!(:other_site) do
        create(:transient_address, :site_using_grid_reference,
               transient_registration: transient_registration,
               grid_reference: "ST 33333 44444",
               description: "Other site")
      end

      before do
        transient_registration.update!(temp_site_id: site_to_edit.id)
      end

      it "updates the selected site address only" do
        result = nil

        expect { result = run_service }
          .not_to change { transient_registration.transient_addresses.site.count }

        aggregate_failures do
          expect(result).to be(true)
          expect(site_to_edit.reload.grid_reference).to eq("ST 99999 88888")
          expect(site_to_edit.description).to eq("Updated site description")
          expect(other_site.reload.grid_reference).to eq("ST 33333 44444")
          expect(other_site.description).to eq("Other site")
        end
      end

      context "when the temporary site ID does not match an address" do
        before do
          transient_registration.update!(temp_site_id: 99_999)
        end

        it "returns false without creating a site address" do
          result = nil

          expect { result = run_service }
            .not_to change { transient_registration.transient_addresses.site.count }

          expect(result).to be(false)
        end
      end

      context "when the temporary site ID matches a non-site address" do
        let!(:contact_address) do
          create(:transient_address, :contact_address,
                 transient_registration: transient_registration,
                 premises: "Contact premises")
        end

        before do
          transient_registration.update!(temp_site_id: contact_address.id)
        end

        it "returns false without changing the non-site address" do
          result = nil

          expect { result = run_service }
            .not_to change { transient_registration.transient_addresses.site.count }

          aggregate_failures do
            expect(result).to be(false)
            expect(contact_address.reload.address_type).to eq("contact")
            expect(contact_address.premises).to eq("Contact premises")
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/MultipleExpectations
