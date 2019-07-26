Rails.application.routes.draw do

  get '/' => 'application#show'

  post 'register' => 'application#register'
  post 'order' => 'application#order'
  post 'check_payment' => 'application#check_payment'

  get 'callback/:result' => 'application#callback'

  get 'coupon_check' => 'application#coupon_check'
  post 'coupon_create' => 'application#coupon_create'

  get 'admin' => 'admin#list'

  get 'admin/applicants/download' => 'admin/applicants#get_applicants_as_word'
  get 'admin/applicants/download_workshops' => 'admin/applicants#get_applicants_workshops_as_word'
  get 'admin/applicants/:id' => 'admin#applicant'
  get 'admin/applicants/unpaid' => 'admin/applicants#unpaid'
  get 'admin/applicants/unpaid_all' => 'admin/applicants#unpaid_all'

  get 'admin/workshops' => 'admin/workshops#index'
  get 'admin/workshops/:workshop_id' => 'admin/workshops#show', as: :admin_workshop
  get 'admin/workshops/download/:workshop_id' => 'admin/workshops#get_applicants_as_word'

  get 'admin/receipts'
  get 'admin/receipts/:is_paid' => 'admin#receipts'

  get 'admin/stocks'

  get 'admin/get_presentations_as_word' => 'admin#get_presentations_as_word'

  get 'admin/login'

  post 'admin/login'
  get 'admin/coupon'

  get 'admin/:applicant_type' => 'admin#list'

end
