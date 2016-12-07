Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  #root 'home#index'
  root 'users#login'
  resources :dashboard do
    collection do
      # get

      # post
    end
  end

  resources :zendesk do
    collection do
      # get

      # post
    end
  end

  resources :users do
    collection do
      # get
      get 'login'
      get 'register'
      get 'logout'
      get 'update_password'
      get 'forgot_password'
      get 'validation_complete'
      get 'reset_password'
      get 'password_changed'
      get 'validate_account'
      get 'authenticate'
      get 'token_expired'
      get 'registration_completed'
      get 'resent_email_notification'
      get 'user_company_exist'
      get 'create_user'
      get 'account_taken'
      get 'locked'
      get 'welcome_page'
      get 'tendercon_steps'
      get 'steps_completed'
      get 'profile'
      get 'company_profile'
      get 'update_user_div'
      get 'edit_profile'
      get 'download_profile'
      get 'hc_download_profile'
      get 'sc_download_profile'
      get 'change_password'
      get 'billing'
      get 'credit_card_details'
      get 'edit_company_profile'
      get 'subscription'

      # post
      post 'authenticate'
      post 'email_authentication'
      post 'update_password'
      post 'validate_user_email'
      post 'generate_new_token'
      post 'create_user'
      post 'get_position_value'
      post 'validate_position'
      post 'validate_tendercon_id'
      post 'get_similar_address'
      post 'get_address_info'
      post 'update_user'
      post 'submit_request'
      post 'check_abn'
      post 'validate_trade'
      post 'get_trade_value'
      post 'lists'
      post 'delete_user'
      post 'activate_user'
      post 'suspend_user'
      post 'get_positions'
      post 'upload_image'
      post 'create_avatar'
      post 'validate_linkedin'
      post 'validate_credit_card_number'
      post 'create_company_avatar'
      post 'create_company_profile'
      post 'add_new_trade'
      post 'get_user_company'
      post 'get_user_avatar'

    end
  end

  resources :home do
    collection do
      # get


      # post

    end
  end

  resources :request_upgrades do
    collection do
      # get


      # post
      post 'save_request_upgrade'

    end
  end

  resources :tenders do
    collection do
      # get
      get 'new_tender'
      get 'my_tender'
      get 'completed'
      get 'invited_tender'
      get 'open_tender'
      get 'document_matrix'
      get 'hc_tender'
      get 'sc_tender'

      # post
      post 'new_site'
      post 'create_document'
      post 'get_documents'
      post 'delete_documents'
      post 'rename_file'
      post 'unzip'
      post 'new_folder'
      post 'move_files'
      post 'add_revision'
      post 'update_revision'
      post 'create_files'
      post 'create_tender_info'
      post 'get_latling'
      post 'create_tender_trades'
      post 'update_document_status'
      post 'new_invite_form'
      post 'invite_sub_contractor'
      post 'publish'
      post 'request_to_quote'
      post 'create_package'
      post 'filter_by_categories'
      post 'search_by_documents'
      post 'create_partitions'
      post 'search_document_package'
      post 'update_package_trades'
      post 'search_by_trades'
      post 'update_folder_list'
      post 'check_document_cnt'
      post 'get_tender_modal'
      post 'search_quotes_by_trades'
      post 'approved_trade_quote'
      post 'get_latest_chat'
      post 'reject_trade_quotes'
      post 'get_latest_sub'
      post 'get_latest_quote'
      post 'invite_more_sub'
      post 'filter_by_trades'
      post 'filter_by_status'
      post 'filter_open_tender'
      post 'get_tender_body'
      post 'approved_tender_request'
      post 'sub_contractor_tabs'
      post 'add_directory'
    end
  end

  resources :open_tenders do

    collection do

      # get

      # post

      post 'get_request_body'

    end
  end

  resources :tender_sites do

    collection do

      # get

      # post

      post 'delete_site'

    end
  end

  resources :trades do
    collection do
      # get
      get 'delete'

      # post
      post 'get_all_lists'
      post 'new_trade'
      post 'delete_trades'

    end
  end

  resources :invoices do
    collection do
      # get
      get 'get_invoice'

      # post

    end
  end

  resources :subscribers do
    collection do
      # get


      # post
      post 'update_lighbox'
    end
  end

  resources :package_downloads do
    collection do
      # get


      # post
      post 'save_download'
    end
  end

  resources :addendas do
    collection do
      # get
      get 'review'
      get 'notify_subcontractors'
      get 'matrix'


      # post
      post 'get_addendas'
      post 'update_quote_due'
      post 'create_addendas'
      post 'create_addenda_document'
      post 'issue_addenda'
      post 'get_documents'
      post 'delete_documents'
    end
  end

  resources :invites do
    collection do
      # get
      get 'success'
      get 'registration'
      get 're_invite_user'
      get 'delete_team_members'
      get 'user'
      get 'decline_tender_invite'


      # post
      post 'sent_invite'
      post 'update_invited_user'
      post 'add_user_position'
      post 'update_plan'
      post 'rejected_request'
      post 'admin_update_plan'
      post 'save_invited_user'
      post 'decline_trade_invite'
      post 'update_tender_invite'
      post 'check_trade_status'
    end
  end

  resources :portfolios do
    collection do
      # get
      get 'delete_portfolio'
      get 'download_portfolio'


      # post
      post 'create_project_avatar'
      post 'get_project_photos'
      post 'create_project_portfolio'
      post 'update_portfolio'
      post 'delete_project_avatar'
    end
  end

  resources :messages do
    collection do
      post 'create_channel'
      post 'save_messages'
      post 'update_unread_messages'
      post 'get_user_lists'
    end
  end

  resources :calendars do
    collection do
      # get

      # post

      post 'get_event_details'
      post 'create_new_event'
    end
  end

  resources :comment_documents do
    collection do
      # get

      # post
      post 'create_comment_document'
      post 'get_documents'
      post 'delete_documents'
      post 'delete_selected_docs'
    end
  end

  resources :rfi_comments do
    collection do
      # get

      # post
      post 'create_comment'

    end
  end

  resources :rfis do
    collection do
      # get
      get 'comments'

      # post
      post 'get_latest_rfis'
      post 'create_rfi_document'
      post 'get_rfi_documents'
      post 'delete_rfi_documents'
      post 'create_rfi'
      post 'get_new_ref'
      post 'delete_rfis'
      post 'download_rfis'
      post 'zip_documents'
      post 'update_status'
      post 'get_rfi_by_trade'
      post 'request_to_resolve'
    end
  end

  resources :quotes do
    collection do
      # get
      get 'view'
      get 'update_quote'

      # post
      post 'get_latest_quotes'
      post 'get_new_ref'
      post 'save_quotes'
      post 'download_quotes'
      post 'delete_quotes'
    end
  end

  resources :quote_documents do
    collection do
      # get


      # post
      post 'create_document'
      post 'get_documents'
      post 'delete_documents'



    end
  end

  resources :quote_document_optionals do
    collection do
      # get


      # post
      post 'create_document'
      post 'get_documents'
      post 'delete_documents'


    end
  end

  resources :shared_rfis do
    collection do


      post 'shared_by_trade'
      post 'shared_by_approved_sub'
    end
  end

  get 'authorize' => 'calendars#gettoken'
  post 'token' => "token#create"

  #get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/:provider/callback', to: 'sessions#create_user_facebook'

  get 'auth/failure' => redirect('/')
  get 'signout' => 'sessions#destroy', as: 'signout'

end
