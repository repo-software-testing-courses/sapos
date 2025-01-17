class CreateClassEnrollmentRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :class_enrollment_requests do |t|
      t.references :enrollment_request
      t.references :course_class
      t.references :class_enrollment
      t.string :status, default: "Solicitada"

      t.timestamps
    end
  end
end
