require "google/apis/sheets_v4"
api = Google::Apis::SheetsV4::SheetsService.new
authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
  json_key_io: File.open(Rails.root.join("google-apis-credentials.json")),
  scope: %w[
    https://www.googleapis.com/auth/spreadsheets
  ]
)

authorizer.fetch_access_token!
api.authorization = authorizer
sheet = api.get_spreadsheet("1n6qkfKk2WUhYf2kpo8VBguc_JY4jVFsMCRPXIZM_L9E")
p sheet
