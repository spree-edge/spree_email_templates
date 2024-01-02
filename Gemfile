source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

group :development, :test do
  gem 'rails', '6.1.7.4'
end

gem 'liquid'

gem 'spree', github: 'spree/spree', branch: 'main'
# gem 'spree_backend', github: 'spree/spree', branch: 'main'
gem 'rails-controller-testing'

gemspec
