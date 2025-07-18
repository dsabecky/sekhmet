require "discordrb"
require "dotenv/load"

bot = Discordrb::Bot.new token: ENV["DISCORD_TOKEN"], parse_self: true

bot.message do |event|
    source = "[#{event.server ? "#{event.server.name}##{event.channel.name}" : "DM"}] #{event.author.name}"
    content = event.message.content

    if event.message.embeds.any?
        event.message.embeds.each do |embed|
            embed_info = []
            embed_info << "title: #{embed.title}" if embed.title
            embed_info << "description: #{embed.description}" if embed.description
            embed_info << "url: #{embed.url}" if embed.url
            embed_info << "fields: #{embed.fields.map { |f| "#{f.name}: #{f.value}" }.join(' | ')}" if embed.fields&.any?
            puts "#{source}: [EMBED] #{embed_info.join(' | ')}"
        end
    end

    puts "#{source}: #{content}" unless content.empty?
end

bot.message(content: "foxtest") do |event|
    event.message.reply!("The quick brown fox jumps over the lazy dog 1234567890", mention_user: true)
end

bot.run