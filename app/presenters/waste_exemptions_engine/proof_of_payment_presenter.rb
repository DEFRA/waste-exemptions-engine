# frozen_string_literal: true

module WasteExemptionsEngine
  class ProofOfPaymentPresenter
    include CanSortExemptions

    PUBLIC_REGISTER_LINK = "https://environment.data.gov.uk/public-register/view/search-waste-exemptions"

    PAYMENT_METHOD_LABELS = {
      Payment::PAYMENT_TYPE_GOVPAY => "Card",
      Payment::PAYMENT_TYPE_MISSING_CARD_PAYMENT => "Card",
      Payment::PAYMENT_TYPE_BANK_TRANSFER => "BACS",
      Payment::PAYMENT_TYPE_OTHER => "Other"
    }.freeze

    def initialize(registration:)
      @registration = registration
    end

    def personalisation
      # Notify placeholder names are case-sensitive. The supplied templates currently
      # use a mixture of canonical and legacy names, so provide both sets of values.
      registration_date = registration.submitted_at.to_date.to_fs(:day_month_year)
      paid_date = payment_date.to_date.to_fs(:day_month_year)
      method = PAYMENT_METHOD_LABELS.fetch(latest_payment.payment_type, latest_payment.payment_type.humanize)

      {
        reg_identifier: registration.reference,
        first_name: registration.contact_first_name,
        last_name: registration.contact_last_name,
        " last_name" => registration.contact_last_name,
        date_registered: registration_date,
        "Date" => registration_date,
        date_paid: paid_date,
        "Date_paid" => paid_date,
        payment_method: method,
        "Payment_Method" => method,
        payment_amount: formatted_payment_amount,
        "payment_Amount" => "£#{formatted_payment_amount}",
        "Exemption_Total" => formatted_payment_amount,
        exemption_breakdown: exemption_breakdown,
        public_register_link: PUBLIC_REGISTER_LINK
      }
    end

    private

    attr_reader :registration

    def successful_payments
      @successful_payments ||= registration.account.payments.select(&:success?)
    end

    def latest_payment
      @latest_payment ||= successful_payments
                          .select { |payment| payment.payment_amount.to_i.positive? }
                          .max_by { |payment| [payment.date_time || payment.created_at, payment.id] }
    end

    def formatted_payment_amount
      CurrencyConversionService.convert_pence_to_pounds(successful_payments.sum(&:payment_amount))
    end

    def payment_date
      latest_payment.date_time || latest_payment.created_at
    end

    def exemption_breakdown
      registration.account.orders.flat_map { |order| order_breakdown(order) }.join("\n")
    end

    def order_breakdown(order)
      lines = exemption_lines(order)
      lines << "* Registration charge: #{format_charge(order.charge_detail.registration_charge_amount)}"
      lines << "* VAT exempt: £0"
    end

    def exemption_lines(order)
      lines = []
      farming_exemptions = farming_exemptions(order)

      if farming_exemptions.any?
        codes = sorted_exemption_codes(farming_exemptions).join(", ")
        lines << "* Farming exemptions (#{codes}): #{format_charge(order.charge_detail.bucket_charge_amount)}"
      end

      non_farming_exemptions(order).each do |exemption|
        charge = format_charge(charges_by_exemption(order)[exemption])
        lines << "* #{exemption.code} #{exemption.summary.capitalize}: #{charge}"
      end

      lines
    end

    def farming_exemptions(order)
      return [] unless order.bucket

      order.exemptions.select { |exemption| order.bucket.exemptions.include?(exemption) }
    end

    def non_farming_exemptions(order)
      sorted_exemptions(order.exemptions - farming_exemptions(order))
    end

    def charges_by_exemption(order)
      @charges_by_order ||= {}
      @charges_by_order[order.id] ||= calculate_charges_by_exemption(order)
    end

    def calculate_charges_by_exemption(order)
      non_farming_exemptions(order).group_by(&:band_id).each_with_object({}) do |(_band_id, exemptions), charges|
        allocate_band_charges(order, exemptions, charges)
      end
    end

    def allocate_band_charges(order, exemptions, charges)
      detail = order.charge_detail.band_charge_details.find do |band_detail|
        band_detail.band_id == exemptions.first.band_id
      end
      initial_amount = detail&.initial_compliance_charge_amount.to_i
      additional_count = exemptions.count - (initial_amount.positive? ? 1 : 0)
      additional_amount = detail&.additional_compliance_charge_amount.to_i / [additional_count, 1].max

      exemptions.each_with_index do |exemption, index|
        charges[exemption] = index.zero? && initial_amount.positive? ? initial_amount : additional_amount
      end
    end

    def format_charge(amount)
      "£#{CurrencyConversionService.convert_pence_to_pounds(amount)}"
    end
  end
end
