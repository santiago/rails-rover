class RoversController < ApplicationController
  # GET /rovers
  # GET /rovers.json
  def index
    @rovers = Rover.all

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @rovers }
    end
  end

  # GET /rovers/1
  def show
    @rover = Rover.find_by_label(params[:id])

    respond_to do |format|
      format.json  { render :json => @rover }
    end
  end

  # POST /rovers
  def create
    @rover = Rover.new(JSON.parse params[:data])
    @rover.x=rand(20) unless @rover.x
    @rover.y=rand(20) unless @rover.y

    respond_to do |format|
      if @rover.save
        format.json { render :json => @rover, :status => :created }
      else
        format.json  { render :json => @rover.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rovers/1
  def update
    @rover = Rover.find(params[:id])

    respond_to do |format|
      if @rover.update_attributes(params[:rover])
        format.json  { render :json => @rover }
      else
        format.json  { render :json => @rover.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rovers/1/move
  # I could have done this all in the controller
  # but did like this to illustrate the use of
  # model methods
  def move
    @rover = Rover.find(params[:id])
    respond_to do |format|
      if @rover.move(params[:distance_x], params[:distance_y])
        format.json  { render :json => @rover }
      else
        format.json { render :json => @rover.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rovers/1
  def destroy
    @rover = Rover.find(params[:id])
    @rover.destroy

    respond_to do |format|
      format.json  { head :ok }
    end
  end
end
