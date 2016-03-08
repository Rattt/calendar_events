class EventsController < ApplicationController

  before_action :only => [:new, :create, :index, :show, :destroy, :calendar, :edit, :update] do
    private_access!
  end
  before_action :set_event, only: [:edit, :update, :show, :destroy]
  before_action :only => [:edit, :update, :destroy] do
    is_my_event?(@event)
  end
  before_action :set_types_event, only: [:edit, :new, :create, :update]

  def new
    @virtual_event = VirtualEvent.new
  end

  def create
    @virtual_event = VirtualEvent.new(virtual_event_params)
    if @virtual_event.save
      flash[:success] = I18n.t('success.created_event')
      redirect_to events_path
    else
      render 'new'
    end
  end

  def update
    @virtual_event = VirtualEvent.new(virtual_event_params.merge({'id' => params['id']}))
    if @virtual_event.update(@event)
      flash[:success] = I18n.t('success.updated_event')
      redirect_to events_path
    else
      render :edit
    end
  end

  def edit
    @virtual_event = VirtualEvent.new(id: @event.id, user_id: @event.user_id, name: @event.name ,
                                      type_event: @event.type_event, date_start: @event.event_dates.get_date_start_first_event_occurs)
  end

  def show
    @date_start = @event.event_dates.get_date_start_first_event_occurs
  end

  def index
    @events = current_user.events
  end

  def calendar
    @event_dates = EventDate.get_dates_point
  end

  def destroy
    @event.destroy
    flash[:notice] = I18n.t('notice.delete_event')
    redirect_to events_path
  end

  private

  def virtual_event_params
    params.require(:virtual_event).permit(:user_id, :name, :type_event, :date_start)
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def set_types_event
    @types_event = Event.type_events.map { |key,value| [I18n.t("event.type_event."+key), key] }
  end
end