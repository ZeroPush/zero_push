if Rails.env.production?
  ZeroPush.auth_token = '<%= @production_token %>'
else
  ZeroPush.auth_token = '<%= @development_token %>'
end
