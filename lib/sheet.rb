require "google/apis/sheets_v4"

module Sheet
  SHEET_ID = ENV["GOOGLE_SHEETS_SHEET_ID"]

  class << self
    def find_email_and_write_name(email, name)
      api = Google::Apis::SheetsV4::SheetsService.new
      authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
        scope: %w[https://www.googleapis.com/auth/spreadsheets]
      )
      authorizer.fetch_access_token!
      api.authorization = authorizer

      values = api.get_spreadsheet_values(SHEET_ID, "A:C", value_render_option: "FORMATTED_VALUE").values
      values.each.with_index(1) do |(e, u, t), i|
        p [e, u, t, i]
        if e == email
          api.update_spreadsheet_value(
            SHEET_ID,
            "B#{i}:C#{i}",
            Google::Apis::SheetsV4::ValueRange.new(
              values: [[name, Time.current.strftime("%Y-%m-%d %H:%M:%S")]]
            ),
            value_input_option: "RAW"
          )
          return true
        end
      end

      false
    end
  end
end
