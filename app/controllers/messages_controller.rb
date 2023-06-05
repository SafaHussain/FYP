class MessagesController < ApplicationController
	require "base64"

	before_action do
		@conversation = Conversation.find(params[:conversation_id])		
	end

	def index
		@messages = @conversation.messages
		@message = @conversation.messages.new
	end

	def new
		@message = conversation.messages.new
	end

	def create
		private_key_path = Rails.root.join('private_key', "#{@conversation.sender_id}")
        private_key = File.read(private_key_path)
	    sender_private_key=Base64.decode64(private_key)

		recipient=User.find_by(id: @conversation.recipient_id)
        recipient_public_key=Base64.decode64(recipient.public_key)
		secure_message = Themis::Smessage.new(sender_private_key, recipient_public_key)

	encrypted_message = secure_message.wrap(message_params[:body])
	message=  encrypted_message.force_encoding("BINARY")
    message = Base64.strict_encode64(message)
		@message = @conversation.messages.create(body: message, user_id: current_user.id)
		
		if @message

			redirect_to conversation_messages_path(@conversation)
		end
	end

	private

	def message_params
		params.require(:message).permit(:body, :user_id)		
	end
end