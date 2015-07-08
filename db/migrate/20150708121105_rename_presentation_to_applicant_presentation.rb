class RenamePresentationToApplicantPresentation < ActiveRecord::Migration
  def change
    rename_table :presentations, :applicant_presentations
  end
end
