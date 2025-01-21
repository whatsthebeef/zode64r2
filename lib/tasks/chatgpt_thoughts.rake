require 'openai'

namespace :thoughts do
  desc "Generate a new thought from the last 100 thoughts and store it in the database"
  task generate_new_thought: :environment do
    # Ensure OpenAI API key is set in environment variables
    api_key = ENV['OPENAI_API_KEY']

    unless api_key
      puts "Error: Please set the OPENAI_API_KEY environment variable."
      exit 1
    end

    client = OpenAI::Client.new(access_token: api_key)

    # Fetch the last 100 thoughts
    thoughts = Thought.order(created_at: :desc).limit(100).pluck(:content)

    if thoughts.empty?
      puts "No thoughts available to process."
      exit 0
    end

    # Prepare the prompt for ChatGPT
    prompt_text = "Here are the last 100 thoughts:\n\n#{thoughts.join('. ')}\n\nGenerate a new insightful thought based on them."

    begin
      response = client.chat(
        parameters: {
          model: "gpt-4",  # or "gpt-3.5-turbo"
          messages: [
            { role: "system", content: "You are a creative assistant generating new thoughts." },
            { role: "user", content: prompt_text }
          ],
          max_tokens: 250
        }
      )

      if response['choices']
        new_thought = response['choices'].first['message']['content'].strip
        Thought.create(content: new_thought)
        puts "New thought saved: #{new_thought}"
      else
        puts "Error: Unable to get a response from ChatGPT."
      end
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
    end
  end
end
