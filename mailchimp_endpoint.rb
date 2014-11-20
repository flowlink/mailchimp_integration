Dir['./lib/**/*.rb'].each(&method(:require))

class MailChimpEndpoint < EndpointBase::Sinatra::Base
  set :logging, true

  Honeybadger.configure do |config|
    config.api_key = ENV['HONEYBADGER_KEY']
    config.environment_name = ENV['RACK_ENV']
  end

  post '/add_to_list' do
    MailChimp::API.host = 'https://api-mailchimp-com-plxacwrjlhgi.runscope.net'

    mailchimp = Mailchimp::API.new(api_key)
    mailchimp.host = 'https://api-mailchimp-com-plxacwrjlhgi.runscope.net'

    list_ids.each {|list_id| subscribe(mailchimp, list_id)}

    result 200, "Successfully subscribed #{email} to the MailChimp list(s)"
  end

  post '/add_order' do
    mailchimp = Mailchimp::API.new(api_key)
    mailchimp.host = 'https://api-mailchimp-com-plxacwrjlhgi.runscope.net'

    mailchimp.ecomm.order_add({
      id: order[:id],
      campaign_id: order[:campaign_id],
      email_id: order[:email_id],
      email: order[:email],
      total: order[:totals][:order],
      order_date: order[:placed_on],
      shipping: order[:totals][:shipping],
      tax: order[:totals][:tax],
      store_id: order[:store_id] || "Wombat",
      store_name: order[:store_name] || "Wombat",
      items: order[:line_items].map do |item|
        {
          product_id: sku_to_id(item[:product_id]),
          sku: item[:product_id],
          product_name: item[:name],
          category_id: item[:category_id] || 0,
          category_name: item[:category_name] || "Wombat",
          qty: item[:quantity],
          cost: item[:price]
          }
      end
   })

   result 200, "Order #{order[:id]} has been sent to MailChimp"
  end

  private

  def sku_to_id(sku)
    sku.each_codepoint.inject(0) {|acc, cur| acc + cur }
  end

  def email
    @payload['member']['email']
  end

  def order
    @payload[:order]
  end

  def list_ids
    Array(@payload['list_id'] || @payload['member']['list_id'])
  end

  def api_key
    @config['mailchimp_api_key']
  end

  def merge_vars
    {
      fname: @payload['member']['first_name'],
      lname: @payload['member']['last_name']
    }.merge(@payload['member'].except(*["email", "first_name", "last_name"]))
  end

  def message_id
    @message[:message_id]
  end

  def subscribe(mailchimp, list_id)
    mailchimp.lists.subscribe(list_id, { email: email }, merge_vars, 'html', false, true, false, false)
  end
end
