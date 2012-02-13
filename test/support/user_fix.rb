Spree::User.class_eval do
  
  class DestroyWithOrdersError < StandardError; end
  
end
