class Admin::ReplacementsController < Admin::BaseController
  before_action :set_replacement, only: [:show, :edit, :update, :destroy]

  # GET /replacements
  def index
    @replacements = Replacement.order(round_id: :asc, id: :asc).all
  end

  # GET /replacements/1
  def show
    @sames = Replacement.
               where(digest: @replacement.digest).
               order(created_at: :asc).
               all

    @teams = Replacement.
               where(team_id: @replacement.team_id,
                     service: @replacement.service).
               order(created_at: :asc).
               all

    @next = Replacement.
              where(team_id: @replacement.team_id,
                    service: @replacement.service).
              where('id > ?', @replacement.id).
              order(id: :asc).
              first

    @instance = Instance.
                  where(team: @replacement.team,
                        service: @replacement.service).
                  first

    @tokens = @instance.
                tokens.
                where('created_at > ?',
                      @replacement.created_at)

    if @next
      @tokens = @tokens.
                  where('created_at < ?',
                        @next.created_at)
    end

    @redemptions = @tokens.map(&:redemptions).flatten
  end

  # GET /replacements/new
  def new
    @replacement = Replacement.new(round_id: 1, team_id: 16)
  end

  # GET /replacements/1/edit
  def edit
  end

  # POST /replacements
  def create
    @replacement = Replacement.new(replacement_params)

    if @replacement.save
      redirect_to @replacement, notice: 'Replacement was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /replacements/1
  def update
    if @replacement.update(replacement_params)
      redirect_to @replacement, notice: 'Replacement was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /replacements/1
  def destroy
    @replacement.destroy
    redirect_to replacements_url, notice: 'Replacement was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_replacement
      @replacement = Replacement.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def replacement_params
      params.require(:replacement).permit(:team_id, :service_id, :round_id, :file)
    end
end
