# frozen_string_literal: true

require_relative "base_resource"

module Fitbank
  module Resources
    # Provides methods for interacting with the Fitbank Pix API.
    #
    # This class encapsulates the API calls related to Account and balance transactions,
    # including fetching information about Account Entry.
    class Account < BaseResource
      def get_account_entry_paged(params = {})
        validate_required_params(params,
                                 %i[mkt_place_id partner_id business_unit_id tax_number start_date end_date page_size
                                    page_index])

        request(
          method: :post,
          path: "/main/execute/GetAccountEntryPaged",
          body: {
            Method: "GetAccountEntryPaged",
            MktPlaceId: params[:mkt_place_id],
            PartnerId: params[:partner_id],
            BusinessUnitId: params[:business_unit_id],
            TaxNumber: params[:tax_number],
            StartDate: params[:start_date],
            EndDate: params[:end_date],
            PageSize: params[:page_size],
            PageIndex: params[:page_index],
            DateTime: params[:date_time],
            OnlyBalance: params[:only_balance],
            Bank: params[:bank],
            BankBranch: params[:bank_branch],
            BankAccount: params[:bank_account],
            BankAccountDigit: params[:bank_account_digit]
          }.compact
        )
      end

      def new_account_company(params = {})
        validate_required_params(params, %i[
                                   partner_id business_unit_id person_name phone_number tax_number mail
                                   company_type constitution_date monthly_income addresses documents persons
                                   was_signed signature_date
                                 ])
        api_body = convert_keys_to_camel_case(params.dup)
        api_body["Method"] = "NewAccount"
        api_body["IsCompany"] = true # Or 1, depending on API expectation

        request(
          method: :post,
          path: "/main/execute/NewAccount", # Path needs to be exactly as API expects
          body: api_body.compact
        )
      end

      def new_account_individual(params = {})
        validate_required_params(params, %i[
                                   partner_id business_unit_id person_name phone_number tax_number mail
                                   publicly_exposed_person birth_date mother_full_name nationality monthly_income
                                   addresses documents was_signed signature_date
                                   # Persons might be optional for individual, or have different structure
                                 ])
        api_body = convert_keys_to_camel_case(params.dup)
        api_body["Method"] = "NewAccount"
        api_body["IsCompany"] = false # Or 0, depending on API expectation

        request(
          method: :post,
          path: "/main/execute/NewAccount", # Path needs to be exactly as API expects
          body: api_body.compact
        )
      end

      def get_account(params = {})
        validate_required_params(params, %i[partner_id business_unit_id tax_number])

        # This endpoint's documentation does not explicitly show camelCase, 
        # but it's safer to assume it might, or just pass PascalCase directly if that's the standard elsewhere.
        # For consistency with NewAccount, let's try converting to camelCase.
        # If it fails, we might need to send them as PascalCase or as is.
        api_body = convert_keys_to_camel_case(params.dup)
        api_body["Method"] = "GetAccount"

        request(
          method: :post,
          path: "/main/execute/GetAccount",
          body: api_body.compact
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
