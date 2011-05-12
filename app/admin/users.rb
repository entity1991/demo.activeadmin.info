ActiveAdmin.register User, :as => "Customer" do

  filter :username
  filter :email
  filter :created_at

  index do
    id_column
    column :username
    column :email
    column :created_at
    default_actions
  end

  show :title => :username do
    panel "Order History" do
      table_for(customer.orders) do
        column("Order", :sortable => :id) {|order| link_to "##{order.id}", admin_order_path(order) }
        column("State")                   {|order| status_tag(order.state) }
        column("Date", :sortable => :checked_out_at){|order| pretty_format(order.checked_out_at) }
        column("Total")                   {|order| number_to_currency order.total_price }
      end
    end
    active_admin_comments
  end

  sidebar "Customer Details", :only => :show do
    attributes_table_for customer, :username, :email, :created_at
  end

  sidebar "Order History", :only => :show do
    attributes_table_for customer do
      row("Total Orders") { customer.orders.complete.count }
      row("Total Value") { number_to_currency customer.orders.complete.sum(:total_price) }
    end
  end

  sidebar "Demo: Check out the Code!" do
    link_to "app/admin/users.rb", "https://github.com/gregbell/activeadmin-store/blob/demo/app/admin/users.rb"
  end
end
