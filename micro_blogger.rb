require 'jumpstart_auth'

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

end

blogger = MicroBlogger.new
blogger.run
