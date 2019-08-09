class ChargesController < ApplicationController

  def create
    Stripe.api_key = Rails.application.credentials.stripe_api_key
    plan_id = params[:plan_id]
    plan = Stripe::Plan.retrieve(plan_id)
    token = params[:stripeToken]

    # customer = if current_user.stripe_id?
    #             Stripe::Customer.retrieve(current_user.stripe_id)
    #           else
    #             Stripe::Customer.create(email: current_user.email, source: token)
    #           end
    Stripe::Customer.create(email: email, source: token)
    subscription = customer.subscription.create(plan: plan.id)

    option = {
      stripe_id: customer.id,
      stripe_subscription_id: subscription.id,
      subsdcribed: true
    }

  end
end
