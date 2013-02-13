class SettingsController < ApplicationController
  # GET /settings
  # GET /settings.json
  def index
    @settings = Setting.all
  end

  # GET /settings/1
  # GET /settings/1.json
  def show
    @setting = Setting.find(params[:id])
  end

  # GET /settings/new
  # GET /settings/new.json
  def new
    @setting = Setting.new
  end

  # GET /settings/1/edit
  def edit
    @setting = Setting.find(params[:id])
  end

  # POST /settings
  # POST /settings.json
  def create
    @setting = Setting.new(params[:setting])

    if @setting.save
      redirect_to(@setting, :notice => 'Setting was successfully created.')
    else
      render(:action => 'new')
    end
  end

  # PUT /settings/1
  # PUT /settings/1.json
  def update
    @setting = Setting.find(params[:id])

    if @setting.update_attributes(params[:setting])
      redirect_to(@setting, :notice => 'Setting was successfully updated.')
    else
      render(:action => 'edit')
    end
  end

  # DELETE /settings/1
  # DELETE /settings/1.json
  def destroy
    @setting = Setting.find(params[:id])
    @setting.destroy

    redirect_to(settings_url)
  end
end
