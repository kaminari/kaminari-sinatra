# frozen_string_literal: true

#models
require 'fake_app/active_record/models'

class SinatraApp < Sinatra::Base
  register Kaminari::Helpers::SinatraHelpers

  get '/users' do
    @users = User.page params[:page]
    erb <<-ERB.dup
<%= @users.map(&:name).join("\n") %>
<%= link_to_previous_page @users, 'previous page', class: 'prev' %>
<%= link_to_next_page @users, 'next page', class: 'next' %>
<%= paginate @users %>
<div class="info"><%= page_entries_info @users %></div>
ERB
  end

  get '/users/index_text.?:format?' do
    @users = User.page params[:page]
    erb <<-ERB.dup
<%= partial 'users/partial1' %>
<%= paginate @users %>
<%= partial 'users/partial2' %>
ERB
  end
end
