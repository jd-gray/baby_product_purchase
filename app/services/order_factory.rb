class OrderFactory
  def initialize(params, is_gift)
    @params = params.symbolize_keys
    @is_gift = is_gift
  end

  def construct_order
    if @is_gift == "true"
      child = Child.find_by full_name: @params[:child_full_name], birthdate: @params[:birthdate], parent_name: @params[:parent_name]
      prior_order = child.orders.last

      order = Order.create(
        child: child,
        shipping_name: @params[:shipping_name],
        product_id: @params[:product_id],
        zipcode: prior_order.zipcode,
        address: prior_order.address,
        user_facing_id: generate_id,
        paid: false
      )
      order.create_gift(from: @params[:from], message: @params[:message])
      order
    else
      child = Child.find_or_create_by(full_name: @params[:child_full_name], birthdate: @params[:birthdate], parent_name: @params[:parent_name])

      Order.create(
        child: child,
        shipping_name: @params[:shipping_name],
        product_id: @params[:product_id],
        zipcode: @params[:zipcode],
        address: @params[:address],
        user_facing_id: generate_id,
        paid: false
      )
    end
  end

  private

  def generate_id
    SecureRandom.uuid[0..7]
  end
end
