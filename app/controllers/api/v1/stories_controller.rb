class Api::V1::StoriesController < ApplicationController
  before_action :doorkeeper_authorize! # Requires access token for all actions
  before_action :set_story, only: %i[ show update ]
  
  # GET /stories
  def index
    @stories = current_resource_owner.stories

    render json: @stories
  end

  # POST /stories
  def create
    @story = Story.new(story_params)

    if @story.save
      render json: @story, status: :created
    else
      render json: @story.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /stories/1
  def update
    if @story.update(story_params)
      render json: @story
    else
      render json: @story.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_story
      @story = current_resource_owner.stories.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def story_params
      params.require(:story).permit(
        :subbject,
        :hero,
        :place,
        :character,
        :object,
        :age
      )
    end
end
