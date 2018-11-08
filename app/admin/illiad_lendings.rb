ActiveAdmin.register Illiad::Lending do
  menu false
  permit_params :institution_id, :request_type, :status, :transaction_date, :transaction_number
  actions :all, :except => [:edit, :update, :destroy]
end