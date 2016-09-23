Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  get 'api/request' => 'servers#index'
  get 'api/serverStatus' => 'servers#status'
  put 'api/kill' => 'servers#kill'
  # When anything else is made as an API call
  match '*unmatched_route', to: 'common#not_found', via: :all
end
