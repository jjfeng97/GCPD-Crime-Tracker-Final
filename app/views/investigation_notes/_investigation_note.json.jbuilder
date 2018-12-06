json.extract! investigation_note, :id, :officer_id, :investigation_id, :content, :date, :created_at, :updated_at
json.url investigation_note_url(investigation_note, format: :json)