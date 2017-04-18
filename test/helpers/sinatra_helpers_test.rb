# frozen_string_literal: true
require 'test_helper'

ERB_TEMPLATE_FOR_PAGINATE = <<EOT
<div>
<ul>
<% @users.each do |user| %>
  <li class="user_info"><%= user.id %></li>
<% end %>
</ul>
<%= paginate @users, @options %>
</div>
EOT

ERB_TEMPLATE_FOR_PREVIOUS_PAGE = <<EOT
<div>
<ul>
<% @users.each do |user| %>
  <li class="user_info"><%= user.id %></li>
<% end %>
</ul>
<%= link_to_previous_page(@users, "Previous!", {:id => 'previous_page_link'}.merge(@options || {})) %>
</div>
EOT

ERB_TEMPLATE_FOR_PREVIOUS_PAGE_WITH_BLOCK = <<EOT
<div>
<ul>
<% @users.each do |user| %>
  <li class="user_info"><%= user.id %></li>
<% end %>
</ul>
<%= link_to_previous_page(@users, "Previous!", {id: 'previous_page_link'}) do '<span id="no_previous_page">No Previous Page</span>' end %>
</div>
EOT

ERB_TEMPLATE_FOR_NEXT_PAGE = <<EOT
<div>
<ul>
<% @users.each do |user| %>
  <li class="user_info"><%= user.id %></li>
<% end %>
</ul>
<%= link_to_next_page(@users, "Next!", {:id => 'next_page_link'}.merge(@options || {})) %>
</div>
EOT

ERB_TEMPLATE_FOR_NEXT_PAGE_WITH_BLOCK = <<EOT
<div>
<ul>
<% @users.each do |user| %>
  <li class="user_info"><%= user.id %></li>
<% end %>
</ul>
<%= link_to_next_page(@users, "Next!", {:id => 'next_page_link'}) do '<span id="no_next_page">No Next Page</span>' end %>
</div>
EOT

class SinatraHelperTest < ActiveSupport::TestCase
  include Rack::Test::Methods
  include Sinatra::TestHelpers

  def last_document
    Nokogiri::HTML(last_response.body)
  end

  setup do
    50.times {|i| User.create! name: "user#{i}"}
  end
  teardown do
    User.delete_all
  end

  sub_test_case '#paginate' do
    setup do
      mock_app do
        register Kaminari::Helpers::SinatraHelpers
        get '/users' do
          @page = params[:page] || 1
          @users = User.page(@page)
          @options = {}
          erb ERB_TEMPLATE_FOR_PAGINATE.dup
        end
      end
    end

    sub_test_case 'normal paginations with Sinatra' do
      setup { get '/users' }

      test 'should have a navigation tag' do
        assert_not_empty last_document.search('nav.pagination')
      end

      test 'should have pagination links' do
        assert_not_empty last_document.search('.page a')
        assert_not_empty last_document.search('.next a')
        assert_not_empty last_document.search('.last a')
      end

      test 'should point to current page' do
        assert_match(/1/, last_document.search('.current').text)

        get '/users?page=2'
        assert_match(/2/, last_document.search('.current').text)
      end

      test 'should load 25 users' do
        assert_equal 25, last_document.search('li.user_info').length
      end

      test 'should preserve params' do
        get '/users?foo=bar'
        last_document.search('.page a').each do |elm|
          assert_match(/foo=bar/, elm.attribute('href').value)
        end
      end
    end

    sub_test_case 'optional paginations with Sinatra' do
      test 'should have 5 windows with 1 gap' do
        mock_app do
          register Kaminari::Helpers::SinatraHelpers
          get '/users' do
            @page = params[:page] || 1
            @users = User.page(@page).per(5)
            @options = {}
            erb ERB_TEMPLATE_FOR_PAGINATE.dup
          end
        end

        get '/users'

        assert_equal 6, last_document.search('.page').length
        assert_equal 1, last_document.search('.gap').length
      end

      test 'should control the inner window size' do
        mock_app do
          register Kaminari::Helpers::SinatraHelpers
          get '/users' do
            @page = params[:page] || 1
            @users = User.page(@page).per(3)
            @options = {window: 10}
            erb ERB_TEMPLATE_FOR_PAGINATE.dup
          end
        end

        get '/users'

        assert_equal 12, last_document.search('.page').length
        assert_equal 1, last_document.search('.gap').length
      end

      test 'should specify a page param name' do
        mock_app do
          register Kaminari::Helpers::SinatraHelpers
          get '/users' do
            @page = params[:page] || 1
            @users = User.page(@page).per(3)
            @options = {param_name: :user_page}
            erb ERB_TEMPLATE_FOR_PAGINATE.dup
          end
        end

        get '/users'

        last_document.search('.page a').each do |elm|
          assert_match(/user_page=\d+/, elm.attribute('href').value)
        end
      end

      test 'Include nested query in query' do
        get '/users', attribute: [:adult, :children]

        assert_match(/users\?attribute%5B%5D=adult&attribute%5B%5D=children/, last_document.search('a').attribute('href').value)
      end
    end
  end

  sub_test_case '#link_to_previous_page' do
    setup do
      mock_app do
        register Kaminari::Helpers::SinatraHelpers
        get '/users' do
          @page = params[:page] || 2
          @users = User.page(@page)
          erb ERB_TEMPLATE_FOR_PREVIOUS_PAGE.dup
        end

        get '/users_placeholder' do
          @page = params[:page] || 2
          @users = User.page(@page)
          erb ERB_TEMPLATE_FOR_PREVIOUS_PAGE_WITH_BLOCK.dup
        end
      end
    end

    sub_test_case 'having more page' do
      test 'should have a more page link' do
        get '/users'

        assert_not_empty last_document.search('a#previous_page_link')
        assert_match(/Previous!/, last_document.search('a#previous_page_link').text)
      end
    end

    sub_test_case 'the first page' do
      test 'should not have a more page link' do
        get '/users?page=1'

        assert_empty last_document.search('a#previous_page_link')
      end

      test 'should have a no more page notation using placeholder' do
        get '/users_placeholder?page=1'

        assert_empty last_document.search('a#previous_page_link')
        assert_not_empty last_document.search('span#no_previous_page')
        assert_match(/No Previous Page/, last_document.search('span#no_previous_page').text)
      end
    end
  end

  sub_test_case '#link_to_next_page' do
    setup do
      mock_app do
        register Kaminari::Helpers::SinatraHelpers
        get '/users' do
          @page = params[:page] || 1
          @users = User.page(@page)
          erb ERB_TEMPLATE_FOR_NEXT_PAGE.dup
        end

        get '/users_placeholder' do
          @page = params[:page] || 1
          @users = User.page(@page)
          erb ERB_TEMPLATE_FOR_NEXT_PAGE_WITH_BLOCK.dup
        end
      end
    end

    sub_test_case 'having more page' do
      test 'should have a more page link' do
        get '/users'

        assert_not_empty last_document.search('a#next_page_link')
        assert_match(/Next!/, last_document.search('a#next_page_link').text)
      end
    end

    sub_test_case 'the last page' do
      test 'should not have a more page link' do
        get '/users?page=2'

        assert_empty last_document.search('a#next_page_link')
      end

      test 'should have a no more page notation using placeholder' do
        get '/users_placeholder?page=2'

        assert_empty last_document.search('a#next_page_link')
        assert_not_empty last_document.search('span#no_next_page')
        assert_match(/No Next Page/, last_document.search('span#no_next_page').text)
      end
    end
  end
end
