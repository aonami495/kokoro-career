class AddDirectReferencesToInternships < ActiveRecord::Migration[7.2]
  def up
    # まず null 許可でカラム追加
    add_reference :internships, :company, foreign_key: true
    add_reference :internships, :job_seeker, foreign_key: true
    add_reference :internships, :job, foreign_key: true

    # 既存データを更新
    execute <<-SQL
      UPDATE internships
      SET company_id = jobs.company_id,
          job_seeker_id = applications.job_seeker_id,
          job_id = applications.job_id
      FROM applications
      JOIN jobs ON applications.job_id = jobs.id
      WHERE internships.application_id = applications.id
    SQL

    # NOT NULL 制約を追加
    change_column_null :internships, :company_id, false
    change_column_null :internships, :job_seeker_id, false
    change_column_null :internships, :job_id, false
  end

  def down
    remove_reference :internships, :company
    remove_reference :internships, :job_seeker
    remove_reference :internships, :job
  end
end
