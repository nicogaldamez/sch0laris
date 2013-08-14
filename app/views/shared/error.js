<% if !@message.blank? %>
  notify('<%= @message %>','error');
<% end %>
