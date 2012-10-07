# Initialize Spree::User
Spree.user_class = "Spree::User"

unless Spree::User.const_defined?(:DestroyWithOrdersError)
  class Spree::User::DestroyWithOrdersError < StandardError; end
end
