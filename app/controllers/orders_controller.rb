class OrdersController < ApplicationController
  def new
    @order = Order.new(product: Product.find(params[:product_id]))

    if params[:is_gift] 
      render :gift
    else
      render :new
    end
  end

  def create
    child = Child.find_or_create_by(child_params)
    @order = Order.create(order_params.merge(child: child, user_facing_id: SecureRandom.uuid[0..7]))
    if @order.valid?
      Purchaser.new.purchase(@order, credit_card_params)
      redirect_to order_path(@order)
    else
      render :new
    end
  end

  def gift_order
    child = Child.find_by(child_params)

    if child.blank?
      redirect_to new_order_path(is_gift: true, product_id: order_params[:product_id]), notice: "Child could not be found, please try another search!"
      return
    end
    last_order = child.orders.last

    @order = Order.new(order_params.merge(zipcode: last_order.zipcode, address: last_order.address, child: child, user_facing_id: SecureRandom.uuid[0..7]))
    @gift = Gift.new(gift_params.merge(order: @order))

    if @order.valid? && @gift.valid?
      Purchaser.new.purchase(@order, credit_card_params)
      redirect_to order_path(@order)
    else
      redirect_to new_order_path(is_gift: true, product_id: order_params[:product_id]), notice: "Your order could not be placed, please contact customer support if you feel this is an error"
    end
  end

  def show
    @order = Order.find_by(id: params[:id]) || Order.find_by(user_facing_id: params[:id])
  end

private

  def order_params
    params.require(:order).permit(:shipping_name, :product_id, :zipcode, :address).merge(paid: false)
  end

  def child_params
    {
      full_name: params.require(:order)[:child_full_name],
      parent_name: params.require(:order)[:shipping_name],
      birthdate: Date.parse(params.require(:order)[:child_birthdate]),
    }
  end

  def gift_params
    params.require(:order).permit(:from, :message)
  end

  def credit_card_params
    params.require(:order).permit(:credit_card_number, :expiration_month, :expiration_year)
  end
end
