class AddUserRefToStudents < ActiveRecord::Migration[6.0]
  def up
    remove_index :professors, name: "index_professors_on_user_id" if index_exists?(:professors, name: "index_professors_on_user_id")
    remove_index :users, name: "index_users_on_invited_by_id" if index_exists?(:users, name: "index_users_on_invited_by_id")
    remove_index :users, name: "index_users_on_invited_by_type_and_invited_by_id" if index_exists?(:users, name: "index_users_on_invited_by_type_and_invited_by_id")

    change_column :users, :id, :integer, limit: 8, unique: true, null: false, auto_increment: true
    change_column :professors, :user_id, :integer, limit: 8
    add_index :professors, :user_id, name: "index_professors_on_user_id" unless index_exists?(:professors, :user_id)
    change_column :users, :invited_by_id, :integer, limit: 8
    add_index :users, :invited_by_id, name: "index_users_on_invited_by_id" unless index_exists?(:users, :invited_by_id)
    add_index :users, [:invited_by_type, :invited_by_id], name: "index_users_on_invited_by_type_and_invited_by_id" unless index_exists?(:users, [:invited_by_type, :invited_by_id])

    add_reference :students, :user, foreign_key: { on_delete: :nullify }
  end

  def down
    remove_reference :students, :user
  end
end
