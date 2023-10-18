# frozen_string_literal: true

module Api
  module V1
    class StoriesController < ApplicationController
      before_action :doorkeeper_authorize! # Requires access token for all actions
      before_action :set_story, only: %i[ show update ]
      after_action :add_story_to_user, only: %i[ create ]
      
      # GET /stories
      def index
        @stories = current_resource_owner.stories
    
        render json: @stories
      end
    
      # POST /stories
      def create
        @story = Story.new(description: generate_story)
        
        if @story.save
          render json: @story, status: :created
        else
          render json: @story.errors, status: :unprocessable_entity
        end
      end
    
      # PATCH/PUT /stories/1
      def update
        head :not_implemented
      end
    
      def destroy
        # Rerturn not implemented
        head :not_implemented
      end
    
      private
        # Use callbacks to share common setup or constraints between actions.
        def set_story
          @story = current_resource_owner.stories.find(params[:id])
        end
    
        # Only allow a list of trusted parameters through.
        def story_params
          params.require(:story).permit(
            :subject,
            :hero,
            :place,
            :character,
            :object,
            :age
          )
        end
    
        # In general I believe that the controller should not be responsible for
        # generating the story. However, in this case, I believe that the
        # controller is the best place for this logic. The reason for this is
        # that the story is generated using an external API, and the controller
        # is the best place to handle this. If the story was generated using
        # a model, then I would move this logic to the model. I would also
        # consider moving this logic to a service object if it was used in
        # multiple places or an Interactor if it was more complex and had multiple steps.
        def generate_story
          openai_client = OpenAI::Client.new
          response = openai_client.completions(
            parameters: {
              model: "gpt-3.5-turbo-instruct",
              prompt: "Write a 10 page story about #{story_params[:subject]} with a hero named #{story_params[:hero]}, set in a place called #{story_params[:place]}, featuring a #{story_params[:character]} which you need to name, and a significant object referred to as #{story_params[:object]}. The story must be age-appropriate for kids between #{story_params[:age]} years old. Split your response into 10 pages, with each page containing 500 characters start each with \"Page 1\", \"Page 2\", etc. And mark the end of the story with \"The End\".",
              max_tokens: 1000,
              temperature: 0.9,
              top_p: 1,
              frequency_penalty: 0.0,
              presence_penalty: 0.6
            }
          )
    
          response.dig("choices", 0, "text")
        end
    
        # Add the story to the current user
        # This is done after the story is created so that if the story fails to
        # be created, it is not added to the user.
        def add_story_to_user
          return unless @story.persisted?
    
          current_resource_owner.stories << @story
        end
    end
  end
end
