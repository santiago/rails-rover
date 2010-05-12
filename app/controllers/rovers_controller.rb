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

  # POST /rovers.json
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
        format.json  { head :ok }
      else
        format.json  { render :json => @rover.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rovers/1/move_1d/:direction/:distance
  def move_1d
    @rover = Rover.find(params[:id])
    @rover.move_1d(params[:direction],params[:distance])
  end

  # PUT /rovers/1/move_2d/:distance_x/:distance_y
  def move_2d
    @rover = Rover.find(params[:id])
    @rover.move_2d(params[:distance_x],params[:distance_y])
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
