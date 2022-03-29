class AddTelephonNumberToCustomers < ActiveRecord::Migration[5.2]
  def change
    add_column :customers, :telephon_number, :string
  end
end
