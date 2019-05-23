require 'rails_helper'

describe V1::ContactsController, type: :controller do

  context 'when request with no valid headers' do
    it 'returns status code 406 if no accept sent' do
      get :index
      expect(response.status).to eq 406
    end

    it 'returns status code 415 if no content type sent' do
      request.accept = 'application/vnd.api+json'
      get :index
      expect(response.status).to eq 415
    end
  end

  context 'when resquest with valid headers' do
    before do
      request.accept = 'application/vnd.api+json'
      request.content_type = 'application/vnd.api+json'
    end

    let(:response_body) { JSON.parse(response.body) }
    let(:contact_first) { Contact.first }

    describe 'GET v1/contacts' do
      let(:expected_pagination_keys) do
         ["self", "first", "prev", "next", "last"]
      end

      it 'returns contacts' do
        get :index

        expect(response.status).to eq 200
        expect(response_body['data'].count).to eq 5
        expect(response_body['links'].keys).to eq expected_pagination_keys
      end
    end

    describe 'GET v1/contacts/1' do
      it 'returns only first contact' do
        get :show, params: { id: Contact.first.id }

        expect(response_body['data']['id']).to eq "#{contact_first.id}"
        expect(response_body['data']['type']).to eq "contacts"
        expect(response_body['data']['attributes']['name'])
          .to eq "#{contact_first.name}"
        expect(response_body['data']['attributes']['email'])
          .to eq "#{contact_first.email}"
        expect(response_body['data']['attributes']['birthdate'])
          .to eq "#{contact_first.birthdate.to_time.iso8601}"
      end
    end
  end
end
