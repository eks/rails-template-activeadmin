def get_file(file)
  get "#{template_url}/#{file}", file
end

def template_url
  "https://raw.githubusercontent.com/eks/rails-template-activeadmin/master"
end

run 'rm Gemfile app/views/layouts/application.html.erb app/helpers/application_helper.rb app/assets/stylesheets/application.css config/locales/en.yml config/database.yml'

get_file 'Gemfile'
get_file 'config/database.yml'

# bundling
run 'bundle install'

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
    config.assets.precompile += [ '.svg', '.eot', '.woff', '.ttf' ]
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

get_file 'app/views/devise/mailer/reset_password_instructions.html.erb'

# aditional assets files
inject_into_file "config/application.rb",
  "\n\n\n    config.time_zone = \"Brasilia\" \n    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**/*.{rb,yml}').to_s] \n
    config.i18n.enforce_available_locales = false \n
    config.i18n.available_locales = [:en, :\"pt-BR\"] \n    config.i18n.default_locale = :\"pt-BR\" \n\n\n\n    # aditional assets \n    config.assets.precompile += [ '.svg', '.eot', '.woff', '.ttf' ]\n    # Fonts path \n    config.assets.paths << Rails.root.join(\"app\", \"assets\", \"fonts\")",
  after: "# config.time_zone = 'Central Time (US & Canada)'"

# basic js files
run 'rm app/assets/javascripts/application.js'
get_file 'app/assets/javascripts/application.js'
get_file 'app/assets/javascripts/dispatcher.js'
get_file 'app/assets/javascripts/jquery.validate.js'
run 'mkdir -p app/assets/javascripts/validate/localization'
get_file 'app/assets/javascripts/validate/localization/messages_pt_BR.js'

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

# activeadmin
generate 'active_admin:install'
get_file 'app/assets/stylesheets/active_admin_custom.css.scss'

inject_into_file 'config/initializers/active_admin.rb', after: '# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.' do <<-CODE
  Rails.application.config.assets.precompile += %w( ckeditor/* )
CODE
end

inject_into_file 'config/routes.rb', after: 'Rails.application.routes.draw do' do <<-CODE
  mount Ckeditor::Engine => '/ckeditor'
CODE
end

# ahoy
generate 'ahoy:stores:active_record -d postgresql-jsonb'

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

get_file 'app/assets/javascript/chosen-scaffold.js.coffee'

generate 'migration add_name_to_admin_users name'

run 'bundle binstubs rspec-core'
run 'bundle binstubs guard'

rake 'db:create'
rake 'db:migrate'
rake 'db:test:prepare'

generate 'pghero:query_stats'
rake 'db:migrate'

run 'wheneverize .'
run 'rm config/schedule.rb'
get_file 'config/schedule.rb'

# git
git :init
git add: '.'
git commit: %Q{ -m 'First commit' }

puts '=================================='
puts 'CHECK SPECS HELPERS spec/rails_helper.rb spec/rails_helper.rb'
