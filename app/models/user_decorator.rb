# This class is defined in spree_auth.. we'll define
unless defined? Spree::User::DestroyWithOrdersError
  Spree::User.class_eval do
    class DestroyWithOrdersError < StandardError; end
  end
end