class AlterLibraryProfilesTable2 < ActiveRecord::Migration[5.1]
  def change
    drop_table :library_profile_profiles do; end

    create_table :library_profile_profiles do |t|
      t.string :metridoc_code
      t.string :oclc_symbol
      t.string :bd_symbol
      t.string :docline_symbol
      t.string :institution_name
      t.string :library_name
      t.string :name_symbol
      t.string :also_called
      t.string :zip_code_location
      t.string :country
      t.string :null_ignore
      t.string :palci
      t.string :trln
      t.string :btaa
      t.string :gwla
      t.string :blc
      t.string :aserl
      t.string :viva
      t.string :bd
    end
  end
end
