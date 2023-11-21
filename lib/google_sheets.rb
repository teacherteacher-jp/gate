require "google/apis/sheets_v4"

class GoogleSheets
  attr_reader :api, :sheet

  def initialize(sheet_id)
    @api = Google::Apis::SheetsV4::SheetsService.new
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      scope: %w[
        https://www.googleapis.com/auth/spreadsheets
      ]
    )

    authorizer.fetch_access_token!
    api.authorization = authorizer
    @sheet = api.get_spreadsheet(sheet_id)
  end
end
