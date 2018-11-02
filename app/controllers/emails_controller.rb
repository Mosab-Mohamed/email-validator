class EmailsController < ApplicationController
  def validate
    email_validation = EmailValidationService.new(params[:email])
    email_validation.validate!

    render json: { **email_validation.response }
  end
end
