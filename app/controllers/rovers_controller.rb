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
        flash[:notice] = 'Rover was successfully updated.'
        format.html { redirect_to(@rover) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rover.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rovers/1
  def destroy
    @rover = Rover.find(params[:id])
    @rover.destroy

    respond_to do |format|
      format.html { redirect_to(rovers_url) }
      format.xml  { head :ok }
    end
  end
end
