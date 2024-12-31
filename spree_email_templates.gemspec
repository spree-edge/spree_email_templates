# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_email_templates/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_email_templates'
  s.version     = SpreeEmailTemplates.version
  s.summary     = 'It streamline the email communication with spree emails templates.'
  s.description = 'This extension simplifies and enhances email communication within your spree-based platform. With pre-configured core email templates, customizable options, the power of liquid gem parsing, is efficient and tailored to your needs. The integration of the Unlayer editor further extends customization possibilities, offering a seamless solution for crafting visually appealing and dynamic email content.'
  s.required_ruby_version = '>= 2.5'

  s.author    = 'Pardeep'
  s.email     = 'pardeep.kumar@bluebash.co'
  s.homepage  = 'https://github.com/Nextband-online/spree_email_templates'
  s.license   = 'BSD-3-Clause'

  # Co-author
  s.metadata = {
    "co-authors" => "Rahul Singh <rahul@bluebash.co>"
  }

  s.files        = `git ls-files`.split("\n").reject { |f| f.match(/^spec/) && !f.match(/^spec\/fixtures/) }
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree', '>= 4.3.2'
  # s.add_dependency 'spree_backend' # uncomment to include Admin Panel changes
  s.add_dependency 'spree_extension'
  s.add_dependency 'liquid', '>= 5.4.0'
  s.add_dependency 'codemirror-rails'

  s.add_development_dependency 'spree_dev_tools'
end
