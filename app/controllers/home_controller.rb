class HomeController < ApplicationController
  
  def index
    
  end

  def redirect_lang
    redirect_to("/#{I18n.locale}/#{params[:path]}",status: 302)
  end
  
end