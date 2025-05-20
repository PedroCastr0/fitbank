# frozen_string_literal: true

require_relative "base_resource"

module Fitbank
  module Resources
    # Provides methods for interacting with the Fitbank Pix API.
    #
    # This class encapsulates the API calls related to Pix transactions,
    # including fetching information about a Pix key and generating outbound Pix payments.
    # It handles request formatting and parameter validation, ensuring that
    # interactions with the Fitbank API are consistent and error-free.
    class Pix < BaseResource
      def get_infos_pix_key(params = {})
        validate_required_params(params, %i[mkt_place_id partner_id business_unit_id pix_key pix_key_type tax_number])

        request(
          method: :post,
          path: "/main/execute/GetInfosPixKey",
          body: {
            Method: "GetInfosPixKey",
            MktPlaceId: params[:mkt_place_id],
            PartnerId: params[:partner_id],
            BusinessUnitId: params[:business_unit_id],
            PixKey: params[:pix_key],
            PixKeyType: params[:pix_key_type],
            TaxNumber: params[:tax_number]
          }.compact
        )
      end

      def generate_pix_out(params = {})
        # Campos obrigatórios mínimos para PIX usando chave PIX
        validate_required_params(params,
                                 %i[
                                   partner_id
                                   business_unit_id
                                   tax_number
                                   bank
                                   bank_branch
                                   bank_account
                                   bank_account_digit
                                   to_tax_number
                                   to_name
                                   pix_key
                                   value
                                   identifier
                                   payment_date
                                 ])

        request(
          method: :post,
          path: "/main/execute/GeneratePixOut",
          body: {
            Method: "GeneratePixOut",
            MktPlaceId: params[:mkt_place_id],
            PartnerId: params[:partner_id],
            BusinessUnitId: params[:business_unit_id],
            TaxNumber: params[:tax_number],
            Bank: params[:bank],
            BankBranch: params[:bank_branch],
            BankAccount: params[:bank_account],
            BankAccountDigit: params[:bank_account_digit],
            ToName: params[:to_name],
            ToTaxNumber: params[:to_tax_number],
            ToBank: params[:to_bank],
            ToISPB: params[:to_ispb],
            ToBankBranch: params[:to_bank_branch],
            ToBankAccount: params[:to_bank_account],
            ToBankAccountDigit: params[:to_bank_account_digit],
            Value: params[:value],
            PixKey: params[:pix_key],
            PixKeyType: params[:pix_key_type],
            AccountType: params[:account_type],
            RateValue: params[:rate_value],
            RateValueType: params[:rate_value_type],
            Identifier: params[:identifier],
            PaymentDate: params[:payment_date],
            Description: params[:description],
            Tags: params[:tags],
            OnlineTransfer: params[:online_transfer],
            SearchProtocol: params[:search_protocol],
            CustomerMessage: params[:customer_message],
            DeviceId: params[:device_id]
          }.compact
        )
      end

      def get_pix_out_by_id(params = {})
        validate_required_params(params, %i[
                                   partner_id
                                   business_unit_id
                                   document_number
                                   tax_number
                                   bank
                                   bank_branch
                                   bank_account
                                   bank_account_digit
                                   identifier
                                 ])

        request(
          method: :post,
          path: "/main/execute/GetPixOutById",
          body: {
            Method: "GetPixOutById",
            PartnerId: params[:partner_id],
            BusinessUnitId: params[:business_unit_id],
            DocumentNumber: params[:document_number],
            TaxNumber: params[:tax_number],
            Bank: params[:bank],
            BankBranch: params[:bank_branch],
            BankAccount: params[:bank_account],
            BankAccountDigit: params[:bank_account_digit],
            Identifier: params[:identifier]
          }.compact
        )
      end

      private

      def validate_required_params(params, required_keys)
        missing_keys = required_keys - params.keys
        return if missing_keys.empty?

        raise ArgumentError, "Missing required parameters: #{missing_keys.join(", ")}"
      end
    end
  end
end
