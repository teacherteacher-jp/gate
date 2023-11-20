require "google/apis/sheets_v4"
api = Google::Apis::SheetsV4::SheetsService.new
authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
  scope: %w[
    https://www.googleapis.com/auth/spreadsheets
  ]
)

authorizer.fetch_access_token!
api.authorization = authorizer
sheet = api.get_spreadsheet(ENV["GOOGLE_SHEETS_SHEET_ID"])
p api.get_spreadsheet_values(sheet.spreadsheet_id, "A:C", value_render_option: "FORMULA").values
