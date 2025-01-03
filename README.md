# Spree Email Templates

Effortlessly customize and manage spree core emails with the this extension. This extension empowers store administrators to design email templates according to their requirements and control the sending of emails with a simple toggle.

It also uses [liquid](https://github.com/Shopify/liquid) gem to parse the email templates and replaces tags with dynamic values.

## Features

- **Manage Core Templates:** The extension comes equipped with pre-configured default core email templates, providing a seamless ready-to-use solution straight out of the box.
- **Supports Customization:** Administrators have the flexibility to update and customize Spree email templates directly from the admin panel, ensuring a tailored and personalized communication approach.
- **Template Activation:** Effortlessly enable or disable specific email templates with a simple activation toggle, giving you control over the types of communications your platform sends out.
- **Template Parsing:** Utilize the power of the liquid gem to parse templates, seamlessly replacing tags with dynamic content. This ensures that your emails are not only customizable but also dynamically generated to suit specific scenarios.
- **Unlayer Editor extended features:** Take advantage of the extended features provided by the [Unlayer editor](https://unlayer.com/) for even better customization of managing email templates. This integration enhances the overall email template management experience, allowing for more sophisticated design and content options.

## Installation

1. Add this extension to your Gemfile with this line:

    ```ruby
    gem 'spree_email_templates'
    ```

2. Install the gem using Bundler

    ```ruby
    bundle install
    ```

3. Copy & run migrations

    ```ruby
    bundle exec rails g spree_email_templates:install
    ```

4. Restart your server

  If your server was running, restart it so that it can find the assets properly.

## Usage

To manage email templates, navigate to the "Email Templates" tab in the main menu of the admin panel. Here, you'll find a list of all available email templates.

### Activate/Deactivate

All templates are activated by default. If you wish to temporarily stop any of them, deactivate the toggler.

### Customization

Click the "Edit" option next to the desired template. This opens the template editor powered by Unlayer, allowing you to customize the template according to your requirements. Make your changes, save, and the modified template will be applied to future email communications.

Now, your customized email templates will be utilized when sending emails from your Spree store.

### Configure Amazon S3 Bucket

You can configure the amazon S3 bucket to store all the images of your email templates, as unlayer supports this out of the box. Please follow the below link to configure storage for your email templates:
[Amazon S3 Configuration Guide](https://docs.unlayer.com/docs/amazon-s3)

## Testing

First bundle your dependencies, then run `rake`. `rake` will default to building the dummy app if it does not exist, then it will run specs. The dummy app can be regenerated by using `rake test_app`.

```shell
bundle update
bundle exec rake
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_email_templates/factories'
```

## Releasing

```shell
bundle exec gem bump -p -t
bundle exec gem release
```

For more options please see [gem-release README](https://github.com/svenfuchs/gem-release)
