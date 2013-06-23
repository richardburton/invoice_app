class AccountsController < ApplicationController

	def home
		@account = current_user.accounts.build
	end

	def show
		@account = Account.find(params[:id])
		@deals = @account.deals
		#@deal = @account.deal
		@invoice = @account.invoices
	end

	def index

	end

	def edit
		@account = Account.find(params[:id])
	end

	def update
	@account = Account.find(params[:id])
	@invoice = @account.invoices.where(email_reminder_approved: false)
		if @account.update_attributes(params[:account])	
			if @invoice
				@invoice.each do |invoice|
					invoice.update_attributes(account_name: @account.name)
					invoice.update_attributes(account_contact_email: @account.contact_email)
					invoice.update_attributes(account_contact_name: @account.contact_name)
					invoice.save
				end
			end		
			flash[:success] = "Deal Updated"
			redirect_to account_path(@account)
		else
			render 'edit'
		end
	end

	def create
		@account = current_user.accounts.build(params[:account])
		@account.user = current_user
		current_user.accounts << @account
		current_user.save
		if @account.save
			flash[:success] = "New account saved"
			redirect_to :controller => :users, :action => :show, :id => current_user.id 
		else
			render 'users/show'
		end
	end

	def destroy
		
	end

	def new
		@account = Account.new
	end

	#def account
	#	@account = Account.new
	#end



end