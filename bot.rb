require 'telegram/bot'
require 'rubygems'
require 'yaml'
require 'erb'
require 'eye'
id = false
token = "499649310:AAGhXHTXaGDXzgRBETofl1spj_tLMdnpfYU"
Telegram::Bot::Client.run(token) do |bot |
	bot.listen do |message |
		case message.text
		when '/start'
			kb = [
				Telegram::Bot::Types::KeyboardButton.new(text: '!list')
			]
			markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)
			bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}!, if you want to see list of files run : !list, or use !deploy filename", reply_markup: markup)
		end
		if message.from.username == "cfcayan"
			id = true
		end	
		if id == true
			case message.text
			when '!list' 
				Dir.glob("*.yml") { | file |
					bot.api.send_message(chat_id: message.chat.id, text: file, reply_markup: markup)
				}
			end
			if message.text.index("!deploy") == 0
				a = message.text
				a.slice!"!deploy "
				Dir.glob(a) { | file |
					bot.api.send_message(chat_id: message.chat.id, text: file, reply_markup: markup)
					loaded_data = YAML.load(ERB.new(File.read(file)).result)
					bot.api.send_message(chat_id: message.chat.id, text: loaded_data.inspect, reply_markup: markup)
				}
			end
			if message.text.index("!eye l") == 0
				a = message.text 
				a.slice!"!eye l "
				Dir.glob(a) { | file |
					bot.api.send_message(chat_id: message.chat.id, text: file, reply_markup: markup)
										output = system "eye l #{file}"
					result = $?.success?
					if $?.exitstatus > 0
						bot.api.send_message(chat_id: message.chat.id, text: "failed", reply_markup: markup)	
					else
						bot.api.send_message(chat_id: message.chat.id, text: "output is #{output}", reply_markup: markup)	
					end}
				end
				if message.text.index("!eye i") == 0
					a = message.text 
					system "eye i"
					if $?.exitstatus > 0
						bot.api.send_message(chat_id: message.chat.id, text: "failed", reply_markup: markup)	
					end
				end
			end					
		end				
	end
