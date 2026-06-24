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
      redirect_to user_path(@request.receiver), status: :created
    else
      flash[:failure] = "Unable to send request."
      redirect_to user_path(@request.receiver), status: :unprocessable_entity
    end
  end

  def accept
    @request.accept!
    flash[:success] = "Request accepted."
    redirect_to user_path(@request.receiver)
  end

  def reject
    @request.reject!
    flash[:success] = "Request rejected."
    redirect_to user_path(@request.receiver)
  end

  def destroy
    if @request.sender != current_user
      flash[:forbidden] = "You can cancel only your own requests."
    elsif @request.destroy
      flash[:success] = "Request canceled."
    else
      flash[:failure] = "Unable to cancel request."
    end

    redirect_to user_path(current_user)
  end

  private
    def request_params
      params.expect(request: %i[ receiver_id type ])
    end

    def set_request
      @request = Request.find(params[:id])
    end

    def handle_already_processed_error
      flash[:forbidden] = "This request has already been processed."
      redirect_to user_path(@request.receiver)
    end
end
