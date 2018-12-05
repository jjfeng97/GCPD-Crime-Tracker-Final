json.extract! investigation, :id, :title, :description, :crime_location, :dated_opened, :date_closed, :solved, :batman_involved, :created_at, :updated_at
json.url investigation_url(investigation, format: :json)
