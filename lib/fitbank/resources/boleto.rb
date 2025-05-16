# frozen_string_literal: true

require_relative "base_resource"

module Fitbank
  module Resources
    # Provides methods for interacting with the Fitbank Boleto API.
    class Boleto < BaseResource
      def get_boleto_in_by_id(params = {})
        validate_required_params(params, %i[partner_id business_unit_id document_number])

        request(
          method: :post,
          path: "/main/execute/GetBoletoInById",
          body: {
            Method: "GetBoletoInById",
            PartnerId: params[:partner_id],
            BusinessUnitId: params[:business_unit_id],
            DocumentNumber: params[:document_number]
          }
        )
      end

      def generate_boleto(params = {})
        validate_required_params(params, %i[
                                   mkt_place_id partner_id business_unit_id group_template
                                   customer_name customer_tax_number customer_mail customer_phone
                                   neighborhood city state zip_code address_line1
                                   mail_to_send phone_to_send
                                   supplier_tax_number supplier_full_name supplier_trading_name supplier_legal_name
                                   rate_value external_number our_number identifier comments products
                                   due_date total_value
                                 ])

        # Convert keys to camelCase for the API, if necessary for this specific endpoint.
        # Assuming generate_boleto expects PascalCase or specific casing as per original implementation for its main keys,
        # but nested structures like 'Products' might need camelCase or careful handling.
        # For now, direct pass-through as it was, unless specific nested keys need conversion.
        api_body = params.dup # Or perform selective key conversion if needed
        api_body[:Method] = "GenerateBoleto"

        # Example if Products' keys needed camelCase (and Products is an array of hashes):
        # if api_body[:products].is_a?(Array)
        #   api_body[:products] = api_body[:products].map { |p| convert_keys_to_camel_case(p) }
        # end

        request(
          method: :post,
          path: "/main/execute/GenerateBoleto",
          body: {
            Method: "GenerateBoleto",
            MktPlaceId: params[:mkt_place_id],
            PartnerId: params[:partner_id],
            BusinessUnitId: params[:business_unit_id],
            GroupTemplate: params[:group_template],
            CustomerName: params[:customer_name],
            CustomerTaxNumber: params[:customer_tax_number],
            CustomerMail: params[:customer_mail],
            CustomerPhone: params[:customer_phone],
            Neighborhood: params[:neighborhood],
            City: params[:city],
            State: params[:state],
            ZipCode: params[:zip_code],
            AddressLine1: params[:address_line1],
            AddressLine2: params[:address_line2],
            MailToSend: params[:mail_to_send],
            PhoneToSend: params[:phone_to_send],
            SupplierTaxNumber: params[:supplier_tax_number],
            SupplierFullName: params[:supplier_full_name],
            SupplierTradingName: params[:supplier_trading_name],
            SupplierLegalName: params[:supplier_legal_name],
            SupplierBank: params[:supplier_bank],
            SupplierBankBranch: params[:supplier_bank_branch],
            SupplierBankAccount: params[:supplier_bank_account],
            SupplierBankAccountDigit: params[:supplier_bank_account_digit],
            SupplierMail: params[:supplier_mail],
            SupplierPhone: params[:supplier_phone],
            RateValue: params[:rate_value],
            RateSent: params[:rate_sent],
            ExternalNumber: params[:external_number],
            OurNumber: params[:our_number],
            Identifier: params[:identifier],
            Comments: params[:comments],
            Products: params[:products],
            DueDate: params[:due_date],
            TotalValue: params[:total_value],
            FineDate: params[:fine_date],
            FinePercent: params[:fine_percent],
            FineValue: params[:fine_value],
            InterestPercent: params[:interest_percent],
            InterestValue: params[:interest_value],
            DiscountDate: params[:discount_date],
            DiscountValue: params[:discount_value],
            DiscountDate2: params[:discount_date2],
            DiscountValue2: params[:discount_value2],
            DiscountDate3: params[:discount_date3],
            DiscountValue3: params[:discount_value3],
            RebateValue: params[:rebate_value],
            Tags: params[:tags],
            OperationVars: params[:operation_vars],
            DivergentPaymentType: params[:divergent_payment_type],
            MinPaymentValue: params[:min_payment_value],
            MaxPaymentValue: params[:max_payment_value],
            ExpirationDays: params[:expiration_days],
            InterestType: params[:interest_type],
            InterestDate: params[:interest_date]
          }.compact # Ensure .compact is used if direct params are passed
        )
      end

      def generate_recurrence_boleto_in(params = {})
        validate_required_params(params, %i[
                                   partner_id business_unit_id payee payer
                                   boleto_information recurrence date values
                                 ])

        api_body = convert_keys_to_camel_case(params.dup) # Use .dup to avoid modifying original params
        api_body["Method"] = "GenerateRecurrenceBoletoIn"

        request(
          method: :post,
          path: "/main/execute/GenerateRecurrenceBoletoIn",
          body: api_body.compact
        )
      end

      # validate_required_params is now in BaseResource
      # convert_keys_to_camel_case is now in BaseResource
      # camel_case_key is now in BaseResource
    end
  end
end
