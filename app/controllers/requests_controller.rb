class RequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_request, only: %i[ destroy accept reject ]
  rescue_from Request::AlreadyProcessedError, with: :handle_already_processed_error

  def create
    # Validates the existence of the receiver.
    receiver = User.find_by!(id: request_params[:receiver_id])
    return redirect_to(root_path, alert: "Invalid receiver") unless receiver

    # Validates the request type sended.
    type_class = request_params[:type].safe_constantize
    return redirect_to(
      root_path,
      alert: "Request type #{request_params[:type]} is invalid",
      status: :bad_request,
    ) unless type_class && type_class <= Request

    # If the validations pass, create a new request.
    @request = Request.new(
      sender: current_user,
      receiver: receiver,
      type: request_params[:type]
    )

    if @request.save
      flash[:success] = "Request sent."
    else
      flash[:error] = "Unable to send request."
    end

    redirect_back fallback_location: root_path, status: :see_other
  end

  def accept
    @request.accept!
    flash[:success] = "Request accepted."
    redirect_back fallback_location: root_path, status: :see_other
  end

  def reject
    @request.reject!
    flash[:success] = "Request rejected."
    redirect_back fallback_location: root_path, status: :see_other
  end

  def destroy
    if @request.sender != current_user
      flash[:error] = "You can cancel only your own requests."
    elsif @request.destroy
      flash[:success] = "Request canceled."
    else
      flash[:error] = "Unable to cancel request."
    end

    redirect_back fallback_location: root_path, status: :see_other
  end

  private
    def request_params
      params.expect(request: %i[ receiver_id type ])
    end

    def set_request
      @request = Request.find(params[:id])
    end

    def handle_already_processed_error
      flash[:error] = "This request has already been processed."
      redirect_back fallback_location: root_path, status: :see_other
    end
end
