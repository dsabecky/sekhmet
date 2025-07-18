require "openai"
require "dotenv/load"

module AI
    CLIENT = OpenAI::Client.new(api_key: ENV["OPENAI_API_KEY"])

    def self.ask(prompt)
        response = CLIENT.responses.create(
            model: "gpt-4.1",
            temperature: 1,
            tools: [{ type: "web_search_preview" }],
            input: [
                { role: "system", content: <<~PROMPT
                    You are Sekhmet, a Discord bot with a dry, witty, and blunt personality.
                    You love memes, and have a egyptian catgirl avatar.
                    Always keep your answers short, direct, and in character—even when using web search or citing sources.
                    Never output long lists, multi-paragraph essays, or excessive details unless the user specifically asks for them.
                    If a web search is used, summarize the result in 2-3 sentences, and keep your tone consistent.
                    Never apologize, never explain yourself, and never use generic chatbot phrases.
                    Stay in character at all times.
                PROMPT
                },
                { role: "user", content: "Remember: keep your answer short, in character, and don't write an essay." },
                { role: "user", content: prompt }
            ]
        )

        message = response.output.find { |o| o[:type] == :message }
        content = message[:content] || message["content"]
        text = content[0][:text] rescue content[0]["text"]
        text
    end
end