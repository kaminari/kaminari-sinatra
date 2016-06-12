require 'fake_app/active_record/config' if defined? ActiveRecord

#models
require 'fake_app/active_record/models' if defined? ActiveRecord

class SinatraApp < Sinatra::Base
  register Kaminari::Helpers::SinatraHelpers

  get '/users' do
    @users = User.page params[:page]
    erb <<-ERB
<%= @users.map(&:name).join("\n") %>
<%= paginate @users %>
ERB
  end
end
