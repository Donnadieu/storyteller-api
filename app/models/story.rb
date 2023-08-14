class Story < ApplicationRecord
  has_many :user_stories
  has_many :users, through: :user_stories

  validates :description, presence: true

  accepts_nested_attributes_for :user_stories, allow_destroy: true


  def self.generate(story_params, current_resource_owner)
    openai_client = OpenAI::Client.new
    response = openai_client.completions(
      parameters: {
        model: "text-davinci-003",
        prompt: "Write a 10 page story about #{story_params[:subject]} with a hero named #{story_params[:hero]}, set in a place called #{story_params[:place]}, featuring a #{story_params[:character]} which you need to name, and a significant object referred to as #{story_params[:object]}. The story must be age-appropriate for kids between #{story_params[:age]} years old. Split your response into 10 pages, with each page containing 500 characters start each with \"Page 1\", \"Page 2\", etc. And mark the end of the story with \"The End\".",
        max_tokens: 1000,
        temperature: 0.9,
        top_p: 1,
        frequency_penalty: 0.0,
        presence_penalty: 0.6
      }
    )

    story = Story.new(
      title: story_params[:title],
      description: response["choices"][0]["text"],
      user_stories_attributes: [
        {
          user_id: current_resource_owner.id
        }
      ]
    )
  end
end
