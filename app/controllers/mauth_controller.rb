class MauthController < ApplicationController
  layout 'mauth'
  before_action :set_betum, only: [:show, :edit, :update, :destroy]

  # GET /beta
  # GET /beta.json
  def index
    new
    # @beta = Betum.all
    # redirect_to new
  end

  # GET /beta/1
  # GET /beta/1.json
  def show

  end

  # GET /beta/new
  def new
    @betum = Betum.new
  end

  # GET /beta/1/edit
  # def edit
  #
  # end

  # POST /beta
  # POST /beta.json
  def create
    @betum = Betum.new(betum_params)

    respond_to do |format|
      if @betum.save
        # format.html { redirect_to :betum_index, notice: 'Betum ' + @betum.id.to_s + ' was successfully created.' }
        format.js # on { render :show, status: :created, location: @betum }
      else
        # format.html { render :new }
        # format.json { render json: @betum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beta/1
  # PATCH/PUT /beta/1.json
  # def update
  #   respond_to do |format|
  #     if @betum.update(betum_params)
  #       format.html { redirect_to @betum, notice: 'Betum was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @betum }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @betum.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /beta/1
  # DELETE /beta/1.json
  # def destroy
  #   @betum.destroy
  #   respond_to do |format|
  #     format.html { redirect_to beta_url, notice: 'Betum was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_betum
      @betum = Betum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def betum_params
      params.require(:betum).permit(:first_name, :last_name, :email, :desc)
    end

end
