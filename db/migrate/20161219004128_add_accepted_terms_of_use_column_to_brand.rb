class AddAcceptedTermsOfUseColumnToBrand < ActiveRecord::Migration[5.0]
  def change
    add_column :brands, :accepted_terms_of_use, :boolean, default: false
  end
end
