Deface::Override.new(
  virtual_path: 'spree/admin/shared/_main_menu',
  name: 'add_mail_tab_to_main_menu',
  insert_after: 'ul#sidebarApps',
  text: <<-HTML
    <% if can? :admin, Template %>
      <ul class="nav nav-sidebar border-bottom" id="sidebarEmail">
        <%= tab 'Email Templates', url: admin_templates_path, icon: "envelope.svg" %>
      </ul>
    <% end %>
  HTML
)
