class OrdersController < ApplicationController
  def new
    @order = Order.new(product: Product.find(params[:product_id]))
  end

  def create
    params = {}
    order_factory_params = params.merge order_params, child_params, gift_params

    @order = OrderFactory.new(order_factory_params, is_gift).construct_order
    if @order.valid?
      Purchaser.new.purchase(@order, credit_card_params)
      redirect_to order_path(@order)
    else
      render :new
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
      child_full_name: params.require(:order)[:child_full_name],
      parent_name: params.require(:order)[:shipping_name],
      birthdate: Date.parse(params.require(:order)[:child_birthdate]),
    }
  end

  def is_gift
    params.require(:order)[:is_gift]
  end

  def gift_params
    params.require(:order).permit(:from, :message)
  end

  def credit_card_params
    params.require(:order).permit(:credit_card_number, :expiration_month, :expiration_year)
  end
end
