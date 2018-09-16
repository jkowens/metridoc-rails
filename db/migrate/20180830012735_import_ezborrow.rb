class ImportEzborrow < ActiveRecord::Migration[5.2]
  def change
    create_table :ezb_bibliographies do |t|
      t.integer :bibliography_id , limit: 8, null: false
      t.string :request_number , limit: 12
      t.string :patron_id , limit: 20
      t.string :patron_type , limit: 1
      t.string :author , limit: 300
      t.string :title , limit: 400
      t.string :publisher , limit: 256
      t.string :publication_place , limit: 256
      t.string :publication_year , limit: 4
      t.string :edition , limit: 24
      t.string :lccn , limit: 32
      t.string :isbn , limit: 24
      t.string :isbn_2 , limit: 24
      t.integer :oclc 
      t.datetime :request_date 
      t.datetime :process_date 
      t.string :pickup_location , limit: 64
      t.integer :borrower 
      t.integer :lender 
      t.string :supplier_code , limit: 20
      t.string :call_number , limit: 256
      t.timestamp :load_time , null: false
      t.integer :version , limit: 8, null: false
      t.string :local_item_found , limit: 1
      t.string :publication_date , limit: 255
    end

    create_table :ezb_call_numbers do |t|
      t.integer :call_number_id , limit: 8, null: false
      t.string :request_number , limit: 12
      t.integer :holdings_seq 
      t.string :supplier_code , limit: 20
      t.string :call_number , limit: 256
      t.datetime :process_date 
      t.timestamp :load_time , null: false
      t.integer :version , limit: 8, null: false
    end

    create_table :ezb_exception_codes do |t|
      t.string :exception_code , limit: 3, null: false
      t.string :exception_code_desc , limit: 64
      t.integer :ezb_exception_code_id , null: false
      t.integer :version , limit: 8, null: false
    end

    create_table :ezb_institutions do |t|
      t.string :catalog_code , limit: 1, null: false
      t.string :institution , limit: 64, null: false
      t.integer :library_id , null: false
      t.integer :ezb_institution_id , limit: 8, null: false
      t.integer :version , limit: 8, null: false
    end

    create_table :ezb_min_ship_dates do |t|
      t.string :request_number , limit: 12, null: false
      t.timestamp :min_ship_date , null: false
    end

    create_table :ezb_patron_types do |t|
      t.string :patron_type , limit: 1, null: false
      t.string :patron_type_desc , limit: 32
      t.integer :ezb_patron_type_id , null: false
    end

    create_table :ezb_print_dates do |t|
      t.integer :print_date_id , limit: 8, null: false
      t.string :request_number , limit: 12
      t.datetime :print_date 
      t.string :note , limit: 256
      t.datetime :process_date 
      t.timestamp :load_time , null: false
      t.integer :library_id 
      t.integer :version , limit: 8, null: false
    end

    create_table :ezb_report_distributions do |t|
      t.string :email_addr , limit: 32, null: false
      t.integer :institution_id , null: false
      t.integer :ezb_report_distribution_id , limit: 8, null: false
      t.integer :version , limit: 8, null: false
      t.string :library_id , limit: 255, null: false
    end

    create_table :ezb_ship_dates do |t|
      t.integer :ship_date_id , limit: 8, null: false
      t.string :request_number , limit: 12
      t.string :ship_date , limit: 24
      t.string :exception_code , limit: 3
      t.datetime :process_date 
      t.timestamp :load_time , null: false
      t.integer :version , limit: 8, null: false
    end

  end
end