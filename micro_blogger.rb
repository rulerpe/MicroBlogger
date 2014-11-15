require 'jumpstart_auth'
require 'bitly'

class MicroBlogger
	attr_reader :client

	def initialize
		puts "Initializing MicroBlogger"
		@client = JumpstartAuth.twitter
	end

	def tweet(message)
		if message.length <= 140
			@client.update(message)
		else
			puts "message too long must under 140"
		end
	end

	def run
		puts "Welcome to the JSL Twitter Client!"
		command = ""
		while command != "q"
			printf "enter command: "
			command = gets.chomp
			part = command.split
			case part[0]
				when 'q' then puts "Goodbye!"
				when 't' then tweet(part[1..-1].join(" "))
				when 'dm' then dm(part[1], part[2..-1].join(" "))
				when 'spam' then spam_my_followers(part[1..-1].join(" "))
				when 'elt' then every_last_twitter
				when 'turl' then tweet(part[1..-2].join(" ") + " " + shorten(part[-1]))
				else
					puts "Sorry, I don's know how to #{command}"
			end
		end
	end

	def dm(target, message)
		puts "Trying to send #{target} this direct message:"
		puts message
		screen_names = @client.followers.collect {|follower| @client.user(follower).screen_name }
		if screen_names.include?(target)
			message = "d @#{target} #{message}"
			tweet(message)
		else
			puts "You can only DM people who follows you"
		end
	end

	def followers_list
		screen_names = []
		@client.followers.each {|follower| screen_names << @client.user(follower).screen_name}
		return screen_names
	end

	def spam_my_followers(message)
		screen_names = followers_list
		screen_names.each{|follower| dm(follower, message)}
	end

	def every_last_twitter
		friends = @client.friends
		friends = friends.sort_by{|friend| @client.user(friend).screen_name.downcase}
		friends.each do |friend|
			puts @client.user(friend).screen_name + "said this on " + creat_time(friend)
			puts @client.user(friend).status.text 
			puts ""
		end
	end

	def creat_time(friend)
		timestamp = @client.user(friend).status.created_at
		timestamp.strftime("%A, %b %d")
	end

	def shorten(original_url)
		Bitly.use_api_version_3
		bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
		bitly.shorten(original_url).short_url
	end
end

blogger = MicroBlogger.new
blogger.run
