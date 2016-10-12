# frozen_string_literal: true
require 'fake_app/active_record/config'

#models
require 'fake_app/active_record/models'

class SinatraApp < Sinatra::Base
  register Kaminari::Helpers::SinatraHelpers

  get '/users' do
    @users = User.page params[:page]
    erb <<-ERB.dup
<%= @users.map(&:name).join("\n") %>
<%= paginate @users %>
ERB
  end
end
