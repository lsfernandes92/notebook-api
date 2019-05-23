module V1
  class ContactsController < ApplicationController
    include ErrorSerializer

    before_action :set_contact, only: [:show, :update, :destroy]

    # GET v1/contacts
    def index
      page_number = params[:page].try(:[], :number)
      per_page =  params[:page].try(:[], :size)

      @contacts = Contact.all.page(page_number).per(per_page)

      if stale?(:etag => @article)
        render json: @contacts
      end
    end

    # GET v1/contacts/1
    def show
      render json: @contact, include: [:kind, :phones, :address]
    end

    # POST v1/contacts
    def create
      @contact = Contact.new(contact_params)

      if @contact.save
        render json: @contact, status: :created, location: @contact
      else
        render json: ErrorSerializer.serialize(@contact.errors), status: :unprocessable_entity
      end
    end

    # PATCH/PUT v1/contacts/1
    def update
      if @contact.update(contact_params)
        render json: @contact
      else
        render json: ErrorSerializer.serialize(@contact.errors), status: :unprocessable_entity
      end
    end

    # DELETE v1/contacts/1
    def destroy
      @contact.destroy
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_contact
        @contact = Contact.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def contact_params
        # params.require(:contact).permit(
        #   :name,
        #   :email,
        #   :birthdate,
        #   :kind_id,
        #   phones_attributes: [:id, :number, :_destroy],
        #   address_attributes: [:id, :street, :city]
        # )
        ActiveModelSerializers::Deserialization.jsonapi_parse(params)
      end
  end
end
