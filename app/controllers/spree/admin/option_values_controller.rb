module Spree
  module Admin
    class OptionValuesController < BaseController
  
      def update_positions
        params[:positions].each do |id, index|
          OptionValue.update_all(['position=?', index], ['id=?', id])
        end
    
        respond_to do |format|
          format.html { redirect_to edit_admin_option_type_url(params[:id]) }
          format.js  { render :text => 'Ok' }
        end
      end

    end
  end
end
