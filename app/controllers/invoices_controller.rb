class InvoicesController < ApplicationController

	def new

	end

	def create
	end

	def edit
		@invoice = Invoice.find(params[:id])
		@invoice_units = @invoice.units
		@invoice_total = @invoice.amount
		 @invoice_basecost = @invoice.basecost 

	end

	def update
		@deal = Deal.find(params[:deal_id])
		@invoice = Invoice.find(params[:id])
		@invoice.update_attributes(params)
		if @invoice.adjust_total == 1
			@invoice.amount = 13
			@invoice.save
			flash[:success] = "Invoice updated"
			redirect_to deal_invoice_path(@deal, @invoice)
		else
			@invoice.amount = 43
			@invoice.save
			flash[:success] = "Invoice updated"
			redirect_to deal_invoice_path(@deal, @invoice)
		end
	end

	def invoice
		@invoice = Invoice.new
	end

	def show
		@account = Account.find_by(params[:account_id])
		@invoice = Invoice.find(params[:id])
		@user = @invoice.user
		@unit = @invoice.units
		@deal = Deal.find(params[:deal_id])
		@invoice_units = @invoice.units
		@invoice_total = @invoice.amount
		@invoice_basecost = @invoice.basecost 
		#@units_tally = @invoice_units.tallys
	end

	def update_and_email_invoice
    	@invoice = Invoice.find(params[:id])
    	@invoice.update_attributes(email_invoice_approved: true)
  	end

  	def email_invoice
  		@invoice = Invoice.find(params[:id])
  		@invoice.update_attributes(email_invoice_approved: true)
  		@invoice.save
  		InvoiceMailer.invoice_to_client(@invoice).deliver
  		redirect_to approve_user_path(@invoice.user)
  	end

  	def email_reminder
  		@invoice = Invoice.find(params[:id])
  		@invoice.update_attributes(email_reminder_approved: true)
  		@invoice.save
  		InvoiceMailer.reminder_to_client(@invoice).deliver
  		redirect_to approve_user_path(@invoice.user)
  	end


  	def client_invoice_view
  		@invoice = Invoice.find(params[:id])
  		@user = @invoice.user
  		@unit = @invoice.units
		@deal = @invoice.deal
		@invoice_units = @invoice.units
		@invoice_total = @invoice.amount
		@invoice_basecost = @invoice.basecost 
  	end
end
