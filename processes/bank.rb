require 'telegram/bot'
require 'rubygems'
require 'yaml'
require 'erb'

token = "499649310:AAGhXHTXaGDXzgRBETofl1spj_tLMdnpfYU"
Telegram::Bot::Client.run(token) do |bot |
    bot.listen do |message |
    case message.text

when '/start'
kb = [
  Telegram::Bot::Types::KeyboardButton.new(text: 'Полностью согласен')
]
markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)

bot.api.send_message(chat_id: message.chat.id, text: "Приветствую, #{message.from.first_name}!, Вы подтверждаете, что ознакомились и согласны http://www.loudthinking.com/ с условиями предоставления услуг?", reply_markup: markup)


when 'Полностью согласен'
kb = [
  Telegram::Bot::Types::KeyboardButton.new(text: 'Кошелек'),
  Telegram::Bot::Types::KeyboardButton.new(text: 'Обмен'),
  Telegram::Bot::Types::KeyboardButton.new(text: 'О сервисе'),
  Telegram::Bot::Types::KeyboardButton.new(text: 'Партнерская программа')
]
markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)
bot.api.send_message(chat_id: message.chat.id, text: "Приветствую, #{message.from.first_name}!, Это быстрый и бесплатный кошелек, а также сервис моментального обмена BTC (Bitcoin).", reply_markup: markup)

when 'Кошелек'
kb = [
  Telegram::Bot::Types::KeyboardButton.new(text: 'Кошелек'),
  Telegram::Bot::Types::KeyboardButton.new(text: 'Обмен'),
  Telegram::Bot::Types::KeyboardButton.new(text: 'О сервисе'),
  Telegram::Bot::Types::KeyboardButton.new(text: 'Партнерская программа')
]
markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)
bot.api.send_message(chat_id: message.chat.id, text: "Приветствую, #{message.from.first_name}!, Это быстрый и бесплатный кошелек, а также сервис моментального обмена BTC (Bitcoin).", reply_markup: markup)



when '!list', '/list'
Dir.glob("*.yml") { | file |
    bot.api.send_message(chat_id: message.chat.id, text: file, reply_markup: markup)
} else
if message.text.index("!deploy") == 0
a = message.text
a.slice!"!deploy "
Dir.glob(a) { | file |
    bot.api.send_message(chat_id: message.chat.id, text: file, reply_markup: markup)
  loaded_data = YAML.load(ERB.new(File.read(file)).result)
  bot.api.send_message(chat_id: message.chat.id, text: loaded_data.inspect, reply_markup: markup)
} else bot.api.send_message(chat_id: message.chat.id, text: "I didn't understand you:(, #{message.from.first_name} ")
end

end
end
end
