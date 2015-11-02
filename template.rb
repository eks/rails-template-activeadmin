def get_file(file)
  get "#{template_url}/#{file}", file
end

def template_url
  "https://raw.githubusercontent.com/eks/rails-template/master"
end

run 'rm Gemfile app/views/layouts/application.html.erb app/helpers/application_helper.rb app/assets/stylesheets/application.css config/locales/en.yml config/database.yml'

get_file 'Gemfile'
get_file 'config/database.yml'

initializer 'generators.rb', <<-CODE
module #{app_name.gsub(/-/, '_').camelize}
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework :rspec, fixture: false, views: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  end
end
CODE

initializer 'action_mailer.rb', <<-CODE
module #{app_name.gsub(/-/, '_').camelize}
  class Application < Rails::Application
    config.action_mailer.default_url_options = { host: 'localhost:3000' }
  end
end
CODE

initializer 'internationalization.rb', <<-CODE
module #{app_name.gsub(/-/, '_').camelize}
  class Application < Rails::Application
    config.time_zone = 'Brasilia'
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**/*.{rb,yml}').to_s]
    config.i18n.enforce_available_locales = false
    config.i18n.available_locales = [:en, :'pt-BR']
    config.i18n.default_locale = :'pt-BR'
  end
end
CODE

initializer 'asset_pipeline.rb', <<-CODE
module #{app_name.gsub(/-/, '_').camelize}
  class Application < Rails::Application
    config.assets.precompile += [ 'admin/module.js', 'admin/module.css', '.svg', '.eot', '.woff', '.ttf' ]
  end
end
CODE

# locales
get_file 'config/locales/en/rails.yml'
get_file 'config/locales/en/admin.yml'
get_file 'config/locales/en/app.yml'
get_file 'config/locales/en/devise.views.yml'
get_file 'config/locales/en/devise.yml'

get_file 'config/locales/pt-BR/rails.yml'
get_file 'config/locales/pt-BR/admin.yml'
get_file 'config/locales/pt-BR/app.yml'
get_file 'config/locales/pt-BR/devise.views.yml'
get_file 'config/locales/pt-BR/devise.yml'

# application layout and helper
get_file 'app/views/layouts/application.html.erb'
get_file 'app/helpers/application_helper.rb'

# error_messages_for
run 'mkdir -p app/views/shared'
get_file 'app/views/shared/_error_messages.html.erb'

# basic sass files
get_file 'app/assets/stylesheets/application/misc/_normalize.scss'
get_file 'app/assets/stylesheets/application/misc/_functions.scss'
get_file 'app/assets/stylesheets/application/misc/_mixins.scss'
get_file 'app/assets/stylesheets/application.css'
get_file 'app/assets/stylesheets/application/imports.scss'

# basic admin assets
get_file 'app/assets/stylesheets/admin/module.css.scss'
get_file 'app/assets/stylesheets/admin/misc/_vars.scss'
get_file 'app/assets/stylesheets/admin/misc/_normalize.scss'
get_file 'app/assets/stylesheets/admin/ui/_buttons.scss'
get_file 'app/assets/stylesheets/admin/ui/_confirmable.scss'
get_file 'app/assets/stylesheets/admin/ui/_forms.scss'
get_file 'app/assets/stylesheets/admin/ui/_header.scss'
get_file 'app/assets/stylesheets/admin/ui/_index.scss'
get_file 'app/assets/stylesheets/admin/ui/_markdown.scss'
get_file 'app/assets/stylesheets/admin/ui/_nav.scss'
get_file 'app/assets/stylesheets/admin/vendor/_avgrund.scss'
get_file 'app/assets/stylesheets/admin/vendor/_meny.scss'
get_file 'app/assets/javascripts/admin/avgrund.js'
get_file 'app/assets/javascripts/admin/bootstrap-markdown.js'

# basic admin views
run 'mkdir -p app/views/admin app/views/admin/passwords app/views/admin/sessions app/views/admin/admins app/views/admin/shared app/views/devise/mailer'
get_file 'app/views/admin/passwords/edit.html.erb'
get_file 'app/views/admin/passwords/new.html.erb'
get_file 'app/views/admin/sessions/new.html.erb'
get_file 'app/views/admin/shared/_links.erb'
get_file 'app/views/admin/shared/_modal_box.html.erb'
get_file 'app/views/devise/mailer/reset_password_instructions.html.erb'

get_file 'app/assets/javascripts/admin/module.js'
get_file 'app/assets/javascripts/admin/meny.js'
get_file 'app/views/layouts/admin.html.erb'

# basic admin controllers
run 'mkdir -p app/controllers/admin'
get_file 'app/controllers/admin/base_controller.rb'
get_file 'app/controllers/admin/passwords_controller.rb'
get_file 'app/controllers/admin/sessions_controller.rb'
get_file 'app/controllers/admin/unlocks_controller.rb'

# basic admin views
get_file 'app/controllers/admin/admins_controller.rb'

get_file 'app/views/admin/admins/index.html.erb'
get_file 'app/views/admin/admins/show.html.erb'
get_file 'app/views/admin/admins/new.html.erb'
get_file 'app/views/admin/admins/edit.html.erb'
get_file 'app/views/admin/admins/_form.html.erb'
get_file 'app/views/admin/admins/destroy.js.erb'
get_file 'app/views/admin/admins/confirm_destroy.js.erb'

# admin helper
get_file 'app/helpers/admin_helper.rb'

# aditional assets files
inject_into_file "config/application.rb",
  "\n\n\n    config.time_zone = \"Brasilia\" \n    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**/*.{rb,yml}').to_s] \n
    config.i18n.enforce_available_locales = false \n
    config.i18n.available_locales = [:en, :\"pt-BR\"] \n    config.i18n.default_locale = :\"pt-BR\" \n\n\n\n    # aditional assets \n    config.assets.precompile += [ 'html5.js', 'admin/module.js', 'admin/module.css', '.svg', '.eot', '.woff', '.ttf' ]\n    # Fonts path \n    config.assets.paths << Rails.root.join(\"app\", \"assets\", \"fonts\")",
  after: "# config.time_zone = 'Central Time (US & Canada)'"

# basic js files
run 'rm app/assets/javascripts/application.js'
get_file 'app/assets/javascripts/application.js'
get_file 'app/assets/javascripts/dispatcher.js'
get_file 'app/assets/javascripts/jquery.validate.js'
run 'mkdir -p app/assets/javascripts/validate/localization'
get_file 'app/assets/javascripts/validate/localization/messages_pt_BR.js'

# bundling
run 'bundle install'

inject_into_file 'config/database.yml', after: 'port: 5432' do <<-CODE

development:
  <<: *defaults
  database: #{app_name.gsub(/-/, '_')}_development

test: &test
  <<: *defaults
  database: #{app_name.gsub(/-/, '_')}_test
CODE
end

# simple form
generate 'simple_form:install --bootstrap'

# pundit
generate 'pundit:install'

# rspec
generate 'rspec:install'

# devise
generate 'devise:install'

# devise
generate 'devise admin'

# admin routes
inject_into_file 'config/routes.rb', after: 'devise_for :admins' do <<-'RUBY'
  , controllers: {
    sessions:  'admin/sessions',
    passwords: 'admin/passwords',
    unlocks:   'admin/unlocks'
  }

  namespace :admin do
    resources :admins do
      member do
        get 'confirm_destroy'
      end
    end
    root to: 'admins#index'
    mount PgHero::Engine, at: 'pghero'
  end
RUBY
end

# adding html responder
inject_into_file 'app/controllers/application_controller.rb', "
  respond_to :html",
  after: 'protect_from_forgery with: :exception'

# Improve README
get_file 'README.md_example'
run 'mv README.md_example README.md'
run 'rm README.rdoc'

# init guard
run 'bundle exec guard init livereload'

run 'mv spec/spec_helper.rb spec/.spec_helper_backup'
get_file 'spec/spec_helper.rb'

run 'mv spec/rails_helper.rb spec/.rails_helper_backup'
get_file 'spec/rails_helper.rb'

generate 'migration add_name_to_admins name'

run 'bundle binstubs rspec-core'
run 'bundle binstubs guard'

rake 'db:create'
rake 'db:migrate'
rake 'db:test:prepare'

# git
git :init
git add: '.'
git commit: %Q{ -m 'First commit' }

generate 'pghero:query_stats'
rake 'db:migrate'

run 'wheneverize .'
inject_into_file 'config/schedule.rb', after: '# Learn more: http://github.com/javan/whenever' do <<-RUBY
  every 5.minutes do
    rake pghero:capture_query_stats
  end
RUBY
end

puts '=================================='
puts 'CHECK SPECS HELPERS spec/rails_helper.rb spec/rails_helper.rb'
